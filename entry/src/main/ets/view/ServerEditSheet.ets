import Form, { FormItemType } from './form/Form';
import { promptAction } from '@kit.ArkUI';
import RpcService from '../service/RpcService';
import Aria2 from '../model/Aria2';
import LoadingWidget from './LoadingWidget';
import { Aria2Utils } from '../utils/Aria2Utils';
import Const from '../static/Const';
import ComponentRef from './ComponentRef';

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

  }

  @Builder
  nothingToBuild() {
  }

  @BuilderParam childBuilder: () => void = this.nothingToBuild;

  aboutToAppear(): void {
    this.serverEditSheetRef?.bind(this)
    if (this.aria2) {
      this.model.set('name', this.aria2.name);
      this.model.set('url', this.aria2.url);
      this.model.set('secret', this.aria2.secret);
    }
  }

  build() {
    Column() {
      this.childBuilder()
    }.onClick(() => {
      this.open();
    }).bindSheet(this.showSheet, this.buildContent()
      , {
        height: SheetSize.LARGE,
        blurStyle: BlurStyle.Thin,
        title: this.buildTopBar(),
        showClose: true,
        backgroundColor: '#ffd9d9d9',
        onWillDismiss: (action) => {
          this.getUIContext().showAlertDialog({
            title: '警告',
            message: '服务器信息未保存,是否关闭',
            isModal: true,
            primaryButton: {
              enabled: true,
              value: '确定',
              action: () => {
                this.close();
              }
            },
            secondaryButton: {
              enabled: true,
              value: '取消',
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
      successMessage: "连接成功",
      failedMessage: "连接失败",
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
      Blank()
    }.width('100%').justifyContent(FlexAlign.SpaceBetween)

  }

  @Builder
  buildContent() {
    Column() {
      Form({
        formRef: this.formRef,
        footer: this.buildFooter,
        groups: [
          {
            option: {
              header: '服务器信息',
              footer: '服务器地址格式为：http(s)://example.com:6800/jsonrpc \n请先测试服务器地址和密钥是否正确，再保存。'
            },
            children: [
              {
                key: 'name',
                label: '名称',
                placeholder: '请输入名称',
                type: FormItemType.input,
                required: true
              },
              {
                key: 'url',
                label: '服务器地址',
                placeholder: '请输入服务器地址',
                type: FormItemType.input,
                required: true
              },
              {
                key: 'secret',
                label: '密钥',
                placeholder: '请输入密钥（可选）',
                type: FormItemType.input,
              }
            ]
          },
        ],
        model: this.model
      })

    }
  }

  @LocalBuilder
  buildFooter() {
    Button('保存', {
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

