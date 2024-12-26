import { SettingKeys } from '../static/PersistentKeys';
import { LengthMetrics, LengthMetricsUnit, LengthUnit, router } from '@kit.ArkUI';
import { bundleManager } from '@kit.AbilityKit';
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct Index {
  @State enableBtn: boolean = false;
  @State showUserAgreement: boolean = false;
  @State showPrivacyPolicy: boolean = false;
  private currentVersion: number = -1;
  private controller: webview.WebviewController = new webview.WebviewController();

  aboutToAppear(): void {
    let bundleInfo =
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    if (bundleInfo) {
      const versionCode = bundleInfo.versionCode;
      const versionName = bundleInfo.versionName;
      this.currentVersion = versionCode;
      let firstLaunchVersion = AppStorage.get<number>(SettingKeys.FIRST_LAUNCH_VERSION);
      if (firstLaunchVersion) {
        if (firstLaunchVersion == versionCode) {
          router.replaceUrl({
            url: 'pages/serverPage'
          })
        }
      }
    }
  }

  build() {
    Column() {
      Blank().height('10%')
      Text($r("app.string.welcome")).fontWeight(FontWeight.Bold).fontSize(48)
      Blank()
      Image($r('app.media.window_icon')).width(100).height(100)
      Blank()
      Row() {
        Checkbox({}).onChange((isCheck) => {
          this.enableBtn = isCheck;
        })
        Text($r('app.string.iAgree'))
        // Button($r('app.string.userAgreement'))
        //   .buttonStyle(ButtonStyleMode.TEXTUAL)
        //   .padding(0)
        //   .stateEffect(false)
        //   .bindSheet(this.showUserAgreement, this.buildUserAgreementContent()
        //     , {
        //       preferType: SheetType.BOTTOM,
        //       showClose: true,
        //       onWillDismiss: () => {
        //         this.showUserAgreement = false;
        //       }
        //     })
        //   .onClick(() => {
        //     this.showUserAgreement = true;
        //   })
        Button($r('app.string.privacyPolicy'))
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .padding(0)
          .stateEffect(false)
          .bindSheet(this.showPrivacyPolicy, this.buildPrivacyPolicyContent(), {
            preferType: SheetType.BOTTOM,
            showClose: true, onWillDismiss: () => {
              this.showPrivacyPolicy = false;
            }

          })
          .onClick(() => {
            this.showPrivacyPolicy = true;
          })
      }

      Button('开始使用', {
        type: ButtonType.Normal
      })
        .enabled(this.enableBtn)
        .borderRadius(5)
        .width('80%')
        .backgroundColor($r('app.color.active_color'))
        .onClick(() => {
          AppStorage.setOrCreate(SettingKeys.FIRST_LAUNCH_VERSION, this.currentVersion)
          router.replaceUrl({
            url: 'pages/serverPage',
          })
        })
      Blank().height('10%')

    }.justifyContent(FlexAlign.Center).height('100%').width('100%')

  }

  @Builder
  buildPrivacyPolicyContent() {
    // Column({ space: 20 }) {
    //   Blank().height('5%')
    //   Text("隐私条款").fontSize(48).fontWeight(FontWeight.Bold)
    //   Text("\r\r隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款隐私条款")
    //     .lineSpacing(new LengthMetrics(20, LengthUnit.PX))
    // }.width('80%').height('100%')
    Web({
      src: 'https://agreement-drcn.hispace.dbankcloud.cn/index.html?lang=zh&agreementId=1582643708103250880',
      controller: this.controller
    })
  }

  @Builder
  buildUserAgreementContent() {
    Text("用户协议")
  }
}