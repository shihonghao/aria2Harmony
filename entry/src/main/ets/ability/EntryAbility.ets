import { AbilityConstant, Configuration, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { display, window } from '@kit.ArkUI';
import { Aria2Keys } from '../static/PersistentKeys';
import DatabaseService from '../service/DatabaseService';
import Aria2 from '../model/Aria2';
import { relationalStore } from '@kit.ArkData';
import Aria2Mapper from '../model/Aria2Mapper';
import { StrUtil } from '@pura/harmony-utils';
import Aria2Service from '../service/Aria2Service';
import { BreakpointConstants } from '../static/BreakpointConstants';

export default class EntryAbility extends UIAbility {
  private windowObj?: window.Window;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {

  }

  onConfigurationUpdate(newConfig: Configuration): void {
    AppStorage.has('language') && AppStorage.setOrCreate('language', newConfig.language);
    AppStorage.has('themeMode') && AppStorage.setOrCreate('themeMode', newConfig.colorMode?.valueOf());
  }

  onDestroy(): void {

  }

  onWindowStageCreate(windowStage: window.WindowStage): void {

    windowStage.getMainWindow().then((data: window.Window) => {
      this.windowObj = data;
      this.updateBreakpoint(this.windowObj.getWindowProperties().windowRect.width);
      this.windowObj.on('windowSizeChange', (windowSize: window.Size) => {
        this.updateBreakpoint(windowSize.width);
      })
    })

    // 加载表单配置
    this.loadFormResource()
    // 初始化数据库
    this.initStorage().then((_) => {
      windowStage.loadContent('pages/serverPage', (err) => {
        if (err.code) {
          hilog.error(0x0000, 'appStartTag', 'Failed to load the content. Cause: %{public}s',
            JSON.stringify(err) ?? '');
          return;
        }
        //初始化设置
        PersistentStorage.persistProp<string>("language", "zh-Hans-CN")
        PersistentStorage.persistProp<number>("themeMode", -1)
        PersistentStorage.persistProp<number>("refreshInterval", 1000)
        let themeMode = AppStorage.get<number>("themeMode");
        let language = AppStorage.get<string>("language");
        this.context.getApplicationContext().setLanguage(language)
        this.context.getApplicationContext()
          .setColorMode(themeMode == 1 ? ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT :
          ConfigurationConstant.ColorMode.COLOR_MODE_DARK)


      });
    }).catch(() => {
      hilog.error(0x0000, 'appStartTag', 'failed init app.');
    })


  }


  private updateBreakpoint(windowWidth: number): void {
    let windowWidthVp = windowWidth / display.getDefaultDisplaySync().densityPixels;
    let curBp: string = '';
    if (windowWidthVp < BreakpointConstants.BREAKPOINT_VALUE_NUMBER[1]) {
      curBp = BreakpointConstants.BREAKPOINT_SM;
    } else if (windowWidthVp < BreakpointConstants.BREAKPOINT_VALUE_NUMBER[2]) {
      curBp = BreakpointConstants.BREAKPOINT_MD;
    } else {
      curBp = BreakpointConstants.BREAKPOINT_LG;
    }
    AppStorage.setOrCreate('currentBreakpoint', curBp);
  }

  initStorage(): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      DatabaseService.init(this.context, {
        name: 'Aria2.db', // 数据库文件名
        securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
        encrypt: false, // 可选参数，指定数据库是否加密，默认不加密
        // customDir: 'customDir/subCustomDir', // 可选参数，数据库自定义路径。数据库将在如下的目录结构中被创建：context.databaseDir + '/rdb/' + customDir，其中context.databaseDir是应用沙箱对应的路径，'/rdb/'表示创建的是关系型数据库，customDir表示自定义的路径。当此参数不填时，默认在本应用沙箱目录下创建RdbStore实例。
        isReadOnly: false // 可选参数，指定数据库是否以只读方式打开。该参数默认为false，表示数据库可读可写。该参数为true时，只允许从数据库读取数据，不允许对数据库进行写操作，否则会返回错误码801。
      }).then((_) => {
        Aria2Mapper.query(() => {
        }).then((aria2s) => {
          let aria2Map: Map<string, Aria2> = new Map();
          let defaultAria2: Aria2 | undefined = undefined;
          aria2s.forEach(aria2 => {
            aria2Map.set(aria2.key, aria2);
            if (aria2.isDefault) {
              defaultAria2 = aria2;
            }
          })
          if (defaultAria2 == undefined && aria2s.length != 0) {
            defaultAria2 = aria2s[0]
          }
          AppStorage.setOrCreate(Aria2Keys.ARIA2S, aria2Map);
          AppStorage.setOrCreate(Aria2Keys.DEFAULT, defaultAria2);
          resolve()
        }).catch(() => {
          reject()
        })
      }).catch(() => reject())
    });
  }

  loadFormResource() {
    this.context.resourceManager.getRawFileContent('globalOptionsField.json').then((data) => {
      Aria2Service.instance.loadGlobalOptionsJson(StrUtil.unit8ArrayToStr(data));
      Aria2Service.instance.loadTaskOptionsJson(StrUtil.unit8ArrayToStr(data));
    })
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
