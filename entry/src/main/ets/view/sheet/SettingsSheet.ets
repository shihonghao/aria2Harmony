import ComponentRef from '../ComponentRef';
import MySelect from '../form/MySelect';
import MyTextInput from '../form/MyTextInput';

@Component
export default struct SettingsSheet {
  ref?: ComponentRef<SettingsSheet>
  @State showSheet: boolean = false;
  @StorageLink('language') language: string = "zh-Hans-CN";
  @StorageLink('themeMode') themeMode: string = "en-US";
  @Watch('updateRefreshInterval') @StorageLink('refreshInterval') refreshInterval: number = 1000;
  @State refreshIntervalString: string = '1000'

  aboutToDisappear(): void {

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
              label: '语言',
              value: this.language,
              options: [
                { label: "中文", value: 'zh-Hans-CN' },
                { label: "English", value: 'en-US' },
              ],
              eventOption: {
                onChange: (value) => {
                  this.getUIContext().getHostContext()?.getApplicationContext().setLanguage(value)
                }
              }
            })
          }

          ListItem() {
            MyTextInput({
              label: '刷新间隔',
              placeholder: '',
              value: this.refreshIntervalString,
              textAlign: TextAlign.End,
              eventOption: {
                onChange: (value) => {
                  this.refreshInterval = parseInt(value);
                }
              }
            })
          }

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
    }.title('设置').titleMode(NavigationTitleMode.Mini)
    .margin({ top: 10 }).expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
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

