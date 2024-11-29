import { FormItemEventOptionInterface } from "./Form"

@Component
export default struct MyToggle {
  @Prop label: string
  @Link value: string
  @Prop readOnly: boolean
  eventOption?: FormItemEventOptionInterface;

  build() {
    Row() {
      Text(this.label).fontSize(12)
      Blank()
      Toggle({ type: ToggleType.Switch, isOn: this.value == 'true' }).onChange((isOn) => {
        let newVal = isOn ? 'true' : 'false'
        if (this.value != newVal) {
          this.value = isOn ? 'true' : 'false'
          this.eventOption?.onChange && this.eventOption.onChange(this.value);
        }
      }).enabled(!this.readOnly)
    }.width('100%')
  }
}