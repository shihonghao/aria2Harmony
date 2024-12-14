import { ServerCard } from '../view/ServerCard';
import Aria2 from '../model/Aria2';
import { Aria2Keys } from '../static/PersistentKeys';
import ServerEditSheet from '../view/sheet/ServerEditSheet';
import MyTransitionEffects from '../effects/MyTransitionEffects';
import { AnimatedIcon } from '../view/AnimatedIcon';
import { router, SymbolGlyphModifier } from '@kit.ArkUI';
import ComponentRef from '../view/ComponentRef';
import { ConfigurationConstant } from '@kit.AbilityKit';
import SettingsSheet from '../view/sheet/SettingsSheet';
import UIUtil from '../utils/UIUtil';


@Entry
@Component
struct ServerPage {
  @Watch('updateTitle') @StorageProp(Aria2Keys.DEFAULT) defaultAria2: Aria2 | undefined = undefined;
  @StorageProp(Aria2Keys.ARIA2S) aria2s: Map<string, Aria2> = new Map();
  title: string | Resource = "Please add an Aria2";
  @State toggle: boolean = false;
  _opacity: number = 0.5;
  serverEditSheetRef = ComponentRef.useRef<ServerEditSheet>();
  settingSheetRef = ComponentRef.useRef<SettingsSheet>();
  @StorageProp('themeMode') currentMode: number =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;

  onPageShow(): void {
    this.updateTitle('');
  }

  build() {
    Stack() {
      SettingsSheet({
        ref: this.settingSheetRef
      })
      Navigation() {
        ServerEditSheet({
          serverEditSheetRef: this.serverEditSheetRef
        })
        if (this.aria2s.size > 0) {
          Scroll() {
            Column() {
              Swiper() {
                ForEach(this.getAria2List(), (item: Aria2, index: number) => {
                  ServerCard({ aria2: item })
                    .margin({
                      left: 20,
                      right: 20,
                      top: 5,
                      bottom: 10
                    })
                })
              }.loop(false).indicator(false)

            }
          }
        } else {
          // Stack() {
          Column({ space: 10 }) {
            Text($r('app.string.please_add_aria2'))
            Button($r('app.string.add'), {
              type: ButtonType.Normal
            }).width('80%')
              .borderRadius(5).onClick(() => {
              this.serverEditSheetRef.value?.open();
            }).backgroundColor($r('app.color.active_color'))
          }.height('80%').justifyContent(FlexAlign.Center)

          // }.position({ x: '50%', y: '40%' }).markAnchor({ x: '50%' })

        }
      }
      .menus(this.buildMenus())
      .title(this.buildTitle())
      .titleMode(NavigationTitleMode.Full)
      .hideBackButton(true)
      .backgroundColor($r('app.color.app_background_color'))
    }
  }

  getAria2List(): Array<Aria2> {
    let aria2List: Array<Aria2> = [];
    this.aria2s.forEach((aria2) => {
      aria2List.push(aria2);
    })

    return aria2List;

  }

  @Builder
  buildSheet() {
    ServerEditSheet()
  }

  @Builder
  buildTitle() {
    if (this.toggle) {
      Text(this.title)
        .margin({ left: 20, top: 10 })
        .fontSize(30)
        .fontWeight(5)
        .transition(MyTransitionEffects.OPACITY_SLIDE_START)
    } else {
      Text(this.title)
        .margin({ left: 20, top: 10 })
        .fontSize(30)
        .fontWeight(5)
        .transition(MyTransitionEffects.OPACITY_SLIDE_START)
    }
  }

  @Builder
  buildMenus() {
    Row() {
      Button({
        type: ButtonType.Circle,
        buttonStyle: ButtonStyleMode.NORMAL
      }) {
        Image($r('app.media.Aria2')).size({ width: 55, height: 55 }).clickEffect({
          level: ClickEffectLevel.MIDDLE,
          scale: 0.3
        })
      }.bindMenu([
        {
          symbolIcon: new SymbolGlyphModifier($r('sys.symbol.streak_jump')),
          value: $r('app.string.go_task'),
          action: () => {
            if (!this.defaultAria2) {
              UIUtil.showConfirmAlertDialog($r('app.string.please_select_aria2'));
              return;
            }
            router.pushUrl({
              url: "pages/taskPage"
            })
          }
        },
        {
          symbolIcon: new SymbolGlyphModifier($r('sys.symbol.plus')),
          value: $r('app.string.add'),
          action: () => {
            this.serverEditSheetRef.value?.open();

          }
        },
        {
          symbolIcon: new SymbolGlyphModifier($r('sys.symbol.house_setting')),
          value: $r('app.string.settings'),
          action: () => {
            this.settingSheetRef.value?.open();

          }
        },
        {
          symbolIcon: new SymbolGlyphModifier($r(this.currentMode == ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
            'sys.symbol.sun' : 'sys.symbol.moon')),
          value: $r(this.currentMode == ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? 'app.string.light_mode' :
            'app.string.dark_mode'),
          action: () => {
            this.getUIContext()
              .getHostContext()?.getApplicationContext().setColorMode(this.currentMode ==
            ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT :
            ConfigurationConstant.ColorMode.COLOR_MODE_DARK)

          }
        },
      ])
    }.margin(20)
  }

  updateTitle(propName: string) {
    let oriTitle = this.title;
    if (this.aria2s.size == 0) {
      this.title = $r('app.string.go_servers')
    } else if (this.defaultAria2?.name) {
      this.title = this.defaultAria2.name;
    } else {
      this.title = $r('app.string.go_servers')
    }
    if (this.title != oriTitle) {
      this.toggle = !this.toggle;
    }
  }
}