import MyTextInput from './MyTextInput';
import Validator, { ValidateResult } from './Validator';
import MyTransitionEffects from '../../effects/MyTransitionEffects';
import ComponentRef from '../ComponentRef';
import MyListTextInput from './MyListTextInput';
import MyToggle from './MyToggle';
import MySelect, { SelectOptionInterface } from './MySelect';
import { nothingToBuild } from '../../utils/UIUtil';
import CommonUtils from '../../utils/CommonUtils';


export class FormUtil {
}

export enum FormItemType {
  input, checkBox, select, switch, list

}

export interface FormItemEventOptionInterface {
  onFocus?: () => void;
  onBlur?: () => void;
  onChange?: (value: string) => void;
}


export interface FormItemOptionInterface {
  key: string;
  label?: string | Resource;
  placeholder?: string | Resource;
  type: FormItemType | string;
  options?: Array<SelectOptionInterface>;
  required?: boolean;
  disable?: boolean;
  readOnly?: boolean;
  validator?: (value: string) => ValidateResult;
  eventOption?: FormItemEventOptionInterface
}

export interface FormOption {
  header?: string
  footer?: string
  dividerMargin?: Margin | Length | LocalizedMargin
  textAlign?: TextAlign
}

export interface FormGroupInterface {
  option: FormGroupOptionInterface
  children: Array<FormItemOptionInterface>
}

@Component
export struct FormItem {
  formItemRef?: ComponentRef<FormItem>;
  @Prop item: FormItemOptionInterface;
  @Prop value: string;
  @Prop isLast: boolean;
  @State validateResult: ValidateResult = { success: true };
  @Consume('formOption') formOption: FormOption;

  aboutToAppear(): void {
    this.formItemRef?.bind(this);
  }

  validate(value?: string): ValidateResult {
    let validator =
      this.item.validator ?? this.item.required ? Validator.NOT_NULL : this.item.validator;
    if (validator) {
      this.validateResult = validator(value ?? this.value);
      return this.validateResult;
    }
    return { success: true }
  }

  build() {
    Column() {
      if (this.item.type == FormItemType.input || this.item.type == 'input') {
        MyTextInput({
          label: this.item.label ?? $r(CommonUtils.i18n( this.item.key.replaceAll('-','_'))),
          placeholder: this.item.placeholder,
          value: this.value,
          readOnly: this.item.readOnly,
          textAlign: this.formOption.textAlign,
          eventOption: {
            onBlur: () => {
              this.validate()
              this.item?.eventOption?.onBlur && this.item?.eventOption.onBlur()
            },
            onChange: this.item?.eventOption?.onChange,
            onFocus: this.item?.eventOption?.onFocus
          },
        })
      } else if (this.item.type == FormItemType.list || this.item.type == 'list') {
        MyListTextInput({
          label: this.item.label ?? $r(CommonUtils.i18n( this.item.key.replaceAll('-','_'))),
          value: this.value,
          readOnly: this.item.readOnly,
          eventOption: this.item.eventOption
        })
      } else if (this.item.type == FormItemType.switch || this.item.type == 'switch') {
        MyToggle({
          label: this.item.label ?? $r(CommonUtils.i18n( this.item.key.replaceAll('-','_'))),
          value: this.value,
          readOnly: this.item.readOnly,
          eventOption: this.item.eventOption
        })
      } else if (this.item.type == FormItemType.select || this.item.type == 'select') {
        MySelect({
          label: this.item.label ?? $r(CommonUtils.i18n( this.item.key.replaceAll('-','_'))),
          value: this.value,
          readOnly: this.item.readOnly,
          options: this.item.options,
          eventOption: this.item.eventOption
        })
      }


      if (!this.isLast) {
        Divider().margin(this.formOption.dividerMargin)
      }

      if (!this.validateResult.success) {
        Text(this.validateResult.message)
          .fontColor(Color.Red)
          .fontSize(10)
          .transition(MyTransitionEffects.OPACITY).margin({ top: 5 })
      }

    }

    .alignItems(HorizontalAlign.Start)
  }
}

export interface FormGroupOptionInterface {
  header?: string | Resource
  footer?: string | Resource
}


@Component
export default struct Form {
  formRef?: ComponentRef<Form>
  @Prop option: FormOption
  @Prop groups: Array<FormGroupInterface>
  @Link model: Map<string, string>
  @BuilderParam header: () => void = nothingToBuild;
  @BuilderParam footer: () => void = nothingToBuild;
  @Provide('formOption') internalOption: FormOption = {}
  itemRefs: Map<FormItemOptionInterface, ComponentRef<FormItem>> = new Map();
  onChange?: (key: string, value: string) => void;

  aboutToAppear(): void {
    this.formRef?.bind(this);
    this.internalOption = this.option ?? this.internalOption;
    this.groups.forEach(group => {
      group.children.forEach(item => {
        item.eventOption = item.eventOption ?? {};
        let oriOnChange = item.eventOption.onChange
        item.eventOption.onChange = (value) => {
          this.model.set(item.key, value)
          this.onChange && this.onChange(item.key, value)
          oriOnChange && oriOnChange(value)
        }
        this.itemRefs.set(item, ComponentRef.useRef<FormItem>())
      })
    })
  }

  validate(): boolean {
    let hasError = false;
    this.itemRefs.forEach(itemRef => {
      if (!itemRef.value?.validate().success) {
        hasError = true;
      }
    });
    return !hasError;
  }

  @LocalBuilder
  buildGroupHeader(header: string) {
    Text(header).fontSize(24).opacity(0.5).margin({ bottom: 10 })
  }

  @LocalBuilder
  buildGroupFooter(footer: string) {
    Text(footer).fontSize(12).opacity(0.5).margin({ top: 10 })
  }

  build() {
    Scroll() {
      Column() {
        List() {
          ForEach(this.groups, (group: FormGroupInterface, index) => {
            ListItem() {
              Text(group.option.header).fontSize(24).opacity(0.5).margin({ bottom: 10, left: 10 })
            }

            ListItemGroup({
              space: 10,
              // header: () => this.buildGroupHeader(group.option.header),
              // footer: () => this.buildGroupFooter(group.option.footer),
            }) {
              ForEach(group.children, (item: FormItemOptionInterface, index: number) => {
                ListItem() {
                  FormItem({
                    formItemRef: this.itemRefs.get(item),
                    item: item,
                    isLast: index == group.children.length - 1,
                    value: this.model.get(item.key)
                  })
                }

              },
                (item: FormItemOptionInterface) => item.key)
            }.padding(20).margin({ bottom: 20 })
            .backgroundColor($r('app.color.card_background_color'))
            .borderRadius(10)

            ListItem() {
              Text(group.option.footer).fontSize(12).opacity(0.5).margin({ bottom: 10, left: 10 })
            }

          }
          )
        }.margin(20)

        this.footer()
      }.height('100%')
    }.scrollable(ScrollDirection.Vertical).scrollBar(BarState.Off).backgroundColor($r('app.color.app_background_color'))
  }
}