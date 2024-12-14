import { router } from '@kit.ArkUI';
import Aria2 from '../model/Aria2';
import GlobalOptions from '../model/GlobalOptions';
import RpcService from '../service/RpcService';
import LoadingWidget from '../view/LoadingWidget';
import Form from '../view/form/Form';
import ComponentRef from '../view/ComponentRef';
import Aria2Service from '../service/Aria2Service';
import { JSONUtil } from '@pura/harmony-utils';
import MyTransitionEffects from '../effects/MyTransitionEffects';

@Entry
@Component
struct GlobalOptionsPage {
  private aria2?: Aria2;
  private promise?: Promise<boolean>;
  @State globalOptions: GlobalOptions | null = null;
  @State model: Map<string, string> = new Map()
  formRef = ComponentRef.useRef<Form>();

  aboutToAppear(): void {
    this.aria2 = router.getParams() as Aria2;
    this.promise = new Promise<boolean>((resolve, reject) => {
      RpcService.connect(this.aria2!).then((version) => {
        RpcService.getGlobalOptions(this.aria2!).then((data) => {
          this.globalOptions = data;
          this.globalOptions.version = version.version;
          this.globalOptions.enabledFeatures = version.enabledFeatures;
          this.model.clear();
          let jsonStr = JSONUtil.beanToJsonStr(this.globalOptions);
          JSONUtil.jsonToMap(jsonStr).forEach((value, key, map) => {
            this.model.set(key, (value == null || value == undefined) ? "" : value.toString());
          })
          resolve(true);
        }).catch(() => {
          reject()
        })
      }).catch(() => {
        reject()
      })

    });
  }

  onPageShow(): void {
  }

  @LocalBuilder
  buildFinish() {
    Column() {
      Form({
        option: {
          dividerMargin: { left: 10 },
          textAlign: TextAlign.End
        },
        formRef: this.formRef,
        footer: undefined,
        groups: Aria2Service.instance.globalOptionFormGroups,
        model: this.model,
        onChange: (key, value) => {
          RpcService.changeGlobalOption(this.aria2!, key, value);
        }
      });
    }.transition(MyTransitionEffects.OPACITY)

  }

  build() {
    Navigation() {
      Stack() {
        LoadingWidget({
          failedMessage: "加载失败，请检查网络或服务器",
          promise: this.promise,
          finishBuilder: this.buildFinish,
        })
      }.width('100%').height('100%')
    }.title(this.aria2?.name).backButtonIcon($r("app.media.window_icon")).titleMode(NavigationTitleMode.Mini)
  }
}