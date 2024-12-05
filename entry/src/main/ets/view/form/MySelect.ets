import { FormItemEventOptionInterface } from './Form'

export interface SelectOptionInterface {
  label: string,
  value: string
}


@Component
export default struct MySelect {
  @Prop label: string | Resource
  @Link value: string
  @Prop readOnly: boolean
  @Require @Prop options: Array<SelectOptionInterface>
  eventOption?: FormItemEventOptionInterface;
  @State menuElement: Array<MenuElement> = [];

  aboutToAppear(): void {
    this.options.forEach(option => {
      this.menuElement.push({
        value: option.label,
        action: (): void => {
          if (option.value != this.value) {
            this.value = option.value;
            this.eventOption?.onChange && this.eventOption.onChange(this.value);
          }
        }
      })
    })

  }

  build() {
    Column() {
      Text(this.label).fontSize(15)
      Blank()
      Row({space:5}) {
        Text(this.getOptionLabel(this.value))
        Image($r('app.media.right'))
          .size({width:12,height:12})
      }.bindMenu(this.menuElement,).justifyContent(FlexAlign.End).alignSelf(ItemAlign.End)
    }.width('100%').margin({ bottom: 5 }).alignItems(HorizontalAlign.Start)
  }

  getOptionLabel(value: string): string {
    return this.options.find((item => item.value == value))?.label ?? "";
  }
}