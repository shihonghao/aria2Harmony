import { FormItemEventOptionInterface } from "./Form"

@Component
export default struct MyToggle {
  @Prop label: string | Resource
  @Link value: string
  @Prop readOnly: boolean
  eventOption?: FormItemEventOptionInterface;

  build() {
    Column() {
      Text(this.label).fontSize(15).alignSelf(ItemAlign.Start)
      Blank()
      Toggle({ type: ToggleType.Switch, isOn: this.value == 'true' }).onChange((isOn) => {
        let newVal = isOn ? 'true' : 'false'
        if (this.value != newVal) {
          this.value = isOn ? 'true' : 'false'
          this.eventOption?.onChange && this.eventOption.onChange(this.value);
        }
      }).enabled(!this.readOnly).alignSelf(ItemAlign.End)
    }.width('100%')
  }
}