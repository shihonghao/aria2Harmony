import { FormItemEventOptionInterface } from './Form'

export interface SelectOptionInterface {
  label: string,
  value: string
}


@Component
export default struct MySelect {
  @Prop label: string
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
    Row() {
      Text(this.label).fontSize(12)
      Blank()
      Row() {
        Text(this.getOptionLabel(this.value))
        SymbolGlyph($r('sys.symbol.chevron_right')).fontSize(24).margin({ left: 5 })

      }.bindMenu(this.menuElement,)
    }.width('100%').margin({ bottom: 5 })
  }

  getOptionLabel(value: string): string {
    return this.options.find((item => item.value == value))?.label ?? "";
  }
}