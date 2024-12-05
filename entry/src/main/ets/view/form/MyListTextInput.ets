import { scaleAnimatedIcon } from '../AnimatedIcon';
import { FormItemEventOptionInterface } from './Form';
import { promptAction, SymbolGlyphModifier } from '@kit.ArkUI';

interface EditDialogOptionInterface {
  value: string;
  onChange?: (value: string) => Promise<void>;
}

@Component
export default struct MyListTextInput {
  @Prop label: string | Resource
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
    Column() {
      Text(this.label).fontSize(15).alignSelf(ItemAlign.Start)
      Blank()
      Row({ space: 5 }) {

        Text(this.list.length.toString())
        Text($r('app.string.items'))

        Image($r('app.media.right'))
          .size({width:12,height:12})

          .bindSheet(this.showSheet, this.buildSheet(), {
            height: SheetSize.LARGE,
            blurStyle: BlurStyle.Thick,
            showClose: false,
            backgroundColor: $r('app.color.app_background_color'),
            onDisappear: () => {
              this.eventOption?.onChange && this.eventOption.onChange(this.list.join(this.delim))
              this.showSheet = false;
            }
          })
      }.alignSelf(ItemAlign.End).justifyContent(FlexAlign.End).width('100%')
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
      Text($r('app.string.edit')).fontSize(25).height('20%').margin(20)
      TextInput({ text: param.value.toString() })
        .margin(10)// .backgroundColor(Color.Transparent)
        .borderRadius(10)
        .textAlign(TextAlign.End)
        .onChange((val) => {
          param.value = val;
        })
      Row() {
        Button($r('app.string.cancel'))
          .type(ButtonType.Capsule)
          .width('50%')
          .onClick(() => {
            this.closeDialog()
          }).fontColor($r('sys.color.ohos_id_text_color_active'))
          .backgroundColor(Color.Transparent)
        Button($r('app.string.confirm')).fontColor($r('sys.color.ohos_id_text_color_active'))
          .type(ButtonType.Capsule)
          .width('50%')
          .onClick(() => {
            param.onChange ? param.onChange(param.value).then(() => {
              this.closeDialog();
            }).catch(() => {
              promptAction.showToast({
                message: $r('app.string.failed')
              })
            }) :
            this.closeDialog()
          })
          .backgroundColor(Color.Transparent)
      }.width('100%')
    }.alignItems(HorizontalAlign.Start).justifyContent(FlexAlign.SpaceBetween).padding({left:20,right:20})
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

          .divider({ strokeWidth: 2, color: Color.Grey })

          .borderRadius(10)
        }
        .margin({ top: 20, left: 20, right: 20 })
        .scrollBar(BarState.Off)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
        .borderRadius(10)
        .backgroundColor($r('app.color.card_background_color'))
        .padding(10)
        .constraintSize({
          minHeight: '50%'
        })

        RelativeContainer().height(50)
      }.alignItems(HorizontalAlign.Center)
    }.margin({ top: 20, bottom: 30 }).title(this.label).titleMode(NavigationTitleMode.Mini).menus(this.readOnly ? [] : [
      {
        value: "添加",
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.plus')),
        action: () => {
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
      }
    ])

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