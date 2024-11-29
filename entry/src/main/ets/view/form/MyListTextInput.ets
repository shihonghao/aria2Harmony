import { scaleAnimatedIcon } from '../AnimatedIcon';
import { FormItemEventOptionInterface } from './Form';
import { promptAction } from '@kit.ArkUI';

interface EditDialogOptionInterface {
  value: string;
  onChange?: (value: string) => Promise<void>;
}

@Component
export default struct MyListTextInput {
  @Prop label: string
  @Prop readOnly: boolean
  @Prop delim: string
  @Link value: string
  eventOption?: FormItemEventOptionInterface;
  @State showSheet: boolean = false;
  @State active: boolean = false;
  @State list: Array<string> = [];
  dialogId?: number;

  aboutToAppear(): void {
    this.list = this.value ? this.value.split(this.delim ?? ',') : [];
  }

  build() {
    Row() {
      Text(this.label).fontSize(12)
      Blank()
      SymbolGlyph($r('sys.symbol.chevron_right')).fontSize(24).bindSheet(this.showSheet, this.buildSheet(), {
        height: SheetSize.LARGE,
        blurStyle: BlurStyle.Thick,
        showClose: false,
        backgroundColor: '#ffd9d9d9',
        onDisappear: () => {
          this.eventOption?.onChange && this.eventOption.onChange(this.list.join(this.delim))
          this.showSheet = false;
        }
      })
    }
    .onClick(() => {
      this.showSheet = !this.showSheet;
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .margin({ top: 5, bottom: 5 })

  }

  close() {
    this.showSheet = false;
  }

  @LocalBuilder
  buildEditDialog(param: EditDialogOptionInterface) {
    Column() {
      Text('编辑').fontSize(25).height('20%').margin(20)
      TextInput({ text: param.value.toString() })
        .margin(10)// .backgroundColor(Color.Transparent)
        .borderRadius(10)
        .textAlign(TextAlign.End)
        .onChange((val) => {
          param.value = val;
        })
      Row() {
        Button("取消")
          .type(ButtonType.Capsule)
          .width('50%')
          .onClick(() => {
            this.closeDialog()
          })
          .backgroundColor(Color.Transparent)
          .fontColor(Color.Black)
        Button("确定")
          .type(ButtonType.Capsule)
          .width('50%')
          .onClick(() => {
            param.onChange ? param.onChange(param.value).then(() => {
              this.closeDialog();
            }).catch(() => {
              promptAction.showToast({
                message: "保存失败"
              })
            }) :
            this.closeDialog()
          })
          .backgroundColor(Color.Transparent)
          .fontColor(Color.Black)
      }.width('100%')
    }.alignItems(HorizontalAlign.Start).justifyContent(FlexAlign.SpaceBetween)
  }

  closeDialog() {
    if (this.dialogId) {
      promptAction.closeCustomDialog(this.dialogId);
      this.dialogId = undefined;
    }
  }

  @Builder
  buildSheet() {
    Navigation() {
      Column() {
        Row() {
          scaleAnimatedIcon($r('app.media.chevron_left'), {
            size: { width: 20, height: 20 },
            fillColor: Color.Black,
            onClick: () => {
              this.close()
            }
          })
          Blank()
          if (!this.readOnly) {
            scaleAnimatedIcon($r('app.media.plus'), {
              size: { width: 30, height: 30 },
              fillColor: Color.Black,
              onClick: () => {
                promptAction.openCustomDialog({
                  builder: () => {
                    this.buildEditDialog({
                      value: "",
                      onChange: (value) => new Promise<void>((resolve) => {
                        this.list.push(value)
                        resolve();
                      })
                    })
                  },
                  width: 350,
                  height: 200,
                  autoCancel: false
                }).then((id) => {
                  this.dialogId = id;
                })
              }
            })
          }

        }.width('100%').padding({ left: 20, right: 20 })

        List() {
          ListItemGroup({ space: 20 }) {
            ForEach(this.list, (item: string, index) => {
              ListItem() {
                Text(item).width('100%')
              }.swipeAction({
                end: {
                  builder: () => {
                    this.buildAction(index)
                  }
                }
              }).height('30')
            })
          }
          .padding(20)
          .backgroundColor(Color.White)
          .divider({ strokeWidth: 2, })
          .borderRadius(10)
        }.margin({ top: 20 }).scrollBar(BarState.Off)
      }.alignItems(HorizontalAlign.Center)
    }.margin({ top: 20, bottom: 30 }).hideTitleBar(true)

  }

  @LocalBuilder
  buildAction(index: number) {
    // 构建尾端滑出组件
    Row() {
      scaleAnimatedIcon($r('app.media.square_and_pencil'), {
        size: { width: 30 },
        onClick: () => {
          promptAction.openCustomDialog({
            builder: () => {
              this.buildEditDialog({
                value: this.list[index],
                onChange: (value) => new Promise<void>((resolve) => {
                  this.list[index] = value;
                  resolve();
                })
              })
            },
            width: 350,
            height: 200,
            autoCancel: false
          }).then((id) => {
            this.dialogId = id;
          })
        }
      })
      Divider().vertical(true).strokeWidth(0).margin({ left: 5, right: 5 })
      scaleAnimatedIcon($r('app.media.delete'), {
        size: { width: 30 },
        onClick: () => {
          this.list.splice(index, 1);
        }
      })
    }.height('100%')

  }
}