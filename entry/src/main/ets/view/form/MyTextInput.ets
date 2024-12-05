import { FormItemEventOptionInterface } from "./Form"

@Component
export default struct MyTextInput {
  @Prop label: string | Resource
  @Prop placeholder: string | Resource
  @Prop required: boolean
  @Prop readOnly: boolean
  @Prop textAlign: TextAlign
  @Link value: string
  eventOption?: FormItemEventOptionInterface;
  controller: TextInputController = new TextInputController()

  build() {
    Row() {
      Column({ space: 5 }) {
        Row() {
          Text(this.label).fontSize(15)
          if (this.required) {
            Text(" *").fontColor(Color.Red)
          }
        }.width('100%')

        TextInput({ text: this.value?.toString(), placeholder: this.placeholder, controller: this.controller })
          .padding(2)
          .backgroundColor(Color.Transparent)
          .borderRadius(0)
          .textAlign(this.textAlign)
          .onChange((val) => {
            if (val != this.value) {
              this.value = val;
              this.eventOption?.onChange && this.eventOption.onChange(val);
            }
          })
          .onBlur(() => {
            this.eventOption?.onBlur && this.eventOption?.onBlur()
          })
          .enabled(!this.readOnly)
      }.alignItems(HorizontalAlign.Start)
    }
  }
}