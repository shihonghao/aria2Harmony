import ComponentRef from '../ComponentRef';
import MySelect from '../form/MySelect';
import MyTextInput from '../form/MyTextInput';
import { ConfigurationConstant } from '@kit.AbilityKit';

@Component
export default struct SettingsSheet {
  ref?: ComponentRef<SettingsSheet>
  @State showSheet: boolean = false;
  @StorageLink('language') language: string = "zh-Hans-CN";
  @StorageLink('themeMode') themeMode: number = 0;
  @Watch('updateRefreshInterval') @StorageLink('refreshInterval') refreshInterval: number = 1000;
  @State refreshIntervalString: string = '1000'
  @Watch('updateThemeMode') @State themeModeString: string = 'dark'

  aboutToDisappear(): void {

  }

  updateThemeMode(changedPropertyName: string) {
    this.themeModeString = this.themeMode == 0 ? 'dark' : 'light'
  }

  aboutToAppear(): void {
    this.ref?.bind(this)
    this.updateRefreshInterval('')
  }

  build() {
    Column().bindSheet(this.showSheet, this.buildContent()
      , {
        onAppear: () => {
        },
        onDisappear: () => {
        },
        onWillDismiss: () => {
          this.close();
        },
        height: SheetSize.MEDIUM,
        blurStyle: BlurStyle.Thin,
        // title: this.buildTopBar(),
        showClose: false,
        backgroundColor: $r('app.color.app_background_color'),
      })
  }

  @Builder
  buildContent() {
    Navigation() {
      Column() {
        List({ space: 20 }) {
          ListItem() {
            MySelect({
              label: $r('app.string.language'),
              value: this.language,
              options: [
                { label: "中文", value: 'zh-Hans-CN' },
                { label: "English", value: 'en-US' },
              ],
              eventOption: {
                onChange: (value) => {
                  this.getUIContext().getHostContext()?.getApplicationContext().setLanguage(value)
                  this.close();
                }
              }
            })
          }

          // ListItem() {
          //   MySelect({
          //     label: $r('app.string.theme_mode'),
          //     value: this.themeModeString,
          //     options: [
          //       { label: (this.language != 'zh-Hans-CN' ? 'dark' : "深色"), value: 'dark' },
          //       { label: (this.language != 'zh-Hans-CN' ? 'light' : "浅色"), value: 'light' },
          //     ],
          //     eventOption: {
          //       onChange: (value) => {
          //         this.getUIContext().getHostContext()?.getApplicationContext().setColorMode(value == 'dark' ?
          //         ConfigurationConstant.ColorMode.COLOR_MODE_DARK : ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
          //       }
          //     }
          //   })
          // }

          // ListItem() {
          //   MyTextInput({
          //     label: '刷新间隔',
          //     placeholder: '',
          //     value: this.refreshIntervalString,
          //     textAlign: TextAlign.End,
          //     eventOption: {
          //       onChange: (value) => {
          //         this.refreshInterval = parseInt(value);
          //       }
          //     }
          //   })
          // }

          ListItem() {
            Column() {
            }
          }
        }.divider({
          strokeWidth: 1,
          color: Color.Grey
        })
      }
      .margin(15)
      .backgroundColor($r('app.color.card_background_color'))
      .padding(20)
      .borderRadius(10)
      .height('100%')
    }.backgroundColor($r('app.color.app_background_color')).title('设置').titleMode(NavigationTitleMode.Mini)
    .padding({ top: 10 }).expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  open(): void {
    this.showSheet = true
  }

  close(): void {
    this.showSheet = false;
  }

  updateRefreshInterval(changedPropertyName: string) {
    this.refreshIntervalString = this.refreshInterval.toString()
  }
}

