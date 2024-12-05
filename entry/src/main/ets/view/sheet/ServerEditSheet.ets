import Form, { FormItemType } from '../form/Form';
import { promptAction, SymbolGlyphModifier } from '@kit.ArkUI';
import RpcService from '../../service/RpcService';
import Aria2 from '../../model/Aria2';
import LoadingWidget from '../LoadingWidget';
import { Aria2Utils } from '../../utils/Aria2Utils';
import Const from '../../static/Const';
import ComponentRef from '../ComponentRef';

@Component
export default struct ServerEditSheet {
  serverEditSheetRef?: ComponentRef<ServerEditSheet>
  @Prop aria2: Aria2;
  @State showSheet: boolean = false;
  @State name?: string = undefined;
  dialogId?: number;
  @State model: Map<string, string> = new Map([
    ['name', ""], ['url', ""], ['secret', ""]
  ])
  formRef: ComponentRef<Form> = ComponentRef.useRef<Form>()

  aboutToDisappear(): void {

    console.log("close")
  }

  @Builder
  nothingToBuild() {
  }

  @BuilderParam childBuilder: () => void = this.nothingToBuild;

  aboutToAppear(): void {
    this.serverEditSheetRef?.bind(this)

  }

  initModel() {
    if (this.aria2) {
      this.model.set('name', this.aria2.name);
      this.model.set('url', this.aria2.url);
      this.model.set('secret', this.aria2.secret);
    } else {
      this.model = new Map([
        ['name', ""], ['url', ""], ['secret', ""]
      ]);
    }
  }

  build() {
    Column() {
      this.childBuilder()
    }.onClick(() => {
      this.open();
    }).bindSheet(this.showSheet, this.buildContent()
      , {
        onAppear: () => {
          this.initModel();
        },
        onDisappear: () => {
          this.model.clear();
        },
        height: SheetSize.LARGE,
        blurStyle: BlurStyle.Thin,
        // title: this.buildTopBar(),
        showClose: false,
        backgroundColor: $r('app.color.app_background_color'),
        onWillDismiss: (action) => {
          this.getUIContext().showAlertDialog({
            title: $r('app.string.warning'),
            message: $r('app.string.server_edit_sheet_dialog_warning_info'),
            isModal: true,
            primaryButton: {
              enabled: true,
              value: $r('app.string.confirm'),
              action: () => {
                this.close();
              }
            },
            secondaryButton: {
              enabled: true,
              value: $r('app.string.cancel'),
              action: () => {

              }
            }
          });
        }
      })
  }

  @Builder
  buildLoadingWidget() {

    LoadingWidget({
      successMessage: $r('app.string.server_edit_sheet_connect_success'),
      failedMessage: $r('app.string.server_edit_sheet_connect_fail'),
      onFinish: () => {
        if (this.dialogId) {
          setTimeout(() => {
            promptAction.closeCustomDialog(this.dialogId);
          }, 500)
        }
      },
      onError: () => {
        if (this.dialogId) {
          setTimeout(() => {
            promptAction.closeCustomDialog(this.dialogId);
          }, 500)
        }
      },
      promise: new Promise<boolean>((resolve, reject) => {
        setTimeout(() => {
          RpcService.connect(this.createAria2()).then(data => {
            resolve(true);
          }).catch(() => {
            reject();
          });
        }, 2000)
      })
    })
  }

  @Builder
  buildTopBar() {
    Row() {
      Button('测试', {
        buttonStyle: ButtonStyleMode.TEXTUAL,
      }).onClick(() => {
        if (this.formRef.value?.validate()) {
          promptAction.openCustomDialog({
            builder: () => {
              this.buildLoadingWidget()
            },
            width: 200,
            height: 200,
            backgroundBlurStyle: BlurStyle.BACKGROUND_THIN,
            autoCancel: false
          }).then((id) => {
            this.dialogId = id;
          })
        }

      }).fontColor(Color.Blue)
    }.width('100%').justifyContent(FlexAlign.End)

  }

  @Builder
  buildContent() {
    Navigation() {
      Column() {
        Form({
          formRef: this.formRef,
          footer: this.buildFooter,
          groups: [
            {
              option: {
                header: $r('app.string.server_edit_sheet_server_info'),
                footer: '服务器地址格式为：http(s)://example.com:6800/jsonrpc \n请先测试服务器地址和密钥是否正确，再保存。'
              },
              children: [
                {
                  key: 'name',
                  label: $r('app.string.server_edit_sheet_name'),
                  placeholder: $r('app.string.server_edit_sheet_name_placeholder'),
                  type: FormItemType.input,
                  required: true
                },
                {
                  key: 'url',
                  label: $r('app.string.server_edit_sheet_url'),
                  placeholder: $r('app.string.server_edit_sheet_url_placeholder'),
                  type: FormItemType.input,
                  required: true
                },
                {
                  key: 'secret',
                  label: $r('app.string.server_edit_sheet_secret'),
                  placeholder: $r('app.string.server_edit_sheet_secret_placeholder'),
                  type: FormItemType.input,
                }
              ]
            },
          ],
          model: this.model
        })

      }
    }.title($r('app.string.add')).titleMode(NavigationTitleMode.Mini)
    .menus([
      {
        value: '测试',
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.connection')),
        action: () => {
          if (this.formRef.value?.validate()) {
            promptAction.openCustomDialog({
              builder: () => {
                this.buildLoadingWidget()
              },
              width: 200,
              height: 200,
              backgroundBlurStyle: BlurStyle.BACKGROUND_THIN,
              autoCancel: false
            }).then((id) => {
              this.dialogId = id;
            })
          }
        }
      }
    ])
    .margin({ top: 10 })
  }

  @LocalBuilder
  buildFooter() {
    Button($r('app.string.server_edit_sheet_save'), {
      type: ButtonType.Normal
    }).borderRadius(5).width('80%').onClick(() => {
      if (this.aria2) {
        this.aria2.name = this.model.get("name") ?? this.aria2.name;
        this.aria2.url = this.model.get("url") ?? this.aria2.url;
        this.aria2.secret = this.model.get("secret") ?? this.aria2.secret;
        Aria2Utils.updateAria2(this.aria2).then(() => {
          this.close()
        });
      } else {
        let newAria2 = this.createAria2(Aria2Utils.generateId(Const.APP_PREFIX));
        Aria2Utils.addAria2(newAria2).then(() => {
          this.close()
        });
      }
    })

  }

  createAria2(key?: string): Aria2 {
    return new Aria2(key ?? "", this.model.get("name") ?? "", this.model.get("url") ?? "",
      this.model.get("secret"));
  }

  open(): void {
    this.showSheet = true
  }

  close(): void {
    this.showSheet = false;
  }
}

