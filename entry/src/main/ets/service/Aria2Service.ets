import { JSONUtil } from '@pura/harmony-utils';
import {
    FormGroupInterface,
    FormGroupOptionInterface,
    FormItemOptionInterface,
    FormItemType
} from '../view/form/Form';
import { SelectOptionInterface } from '../view/form/MySelect';

export default class Aria2Service {
  static instance: Aria2Service = new Aria2Service();
  globalOptionFormGroups: Array<FormGroupInterface> = [];
  taskOptionFormGroups: Array<FormGroupInterface> = [];

  loadGlobalOptionsJson(json: string) {
    let jsonMap = JSONUtil.jsonToMap(json);
    let arr = jsonMap.get('globalOptionFields') as Array<object>;
    arr.forEach(item => {

      let title = item['title'] as string;
      let fields = item['fields'] as Array<object>

      let groupOption: FormGroupOptionInterface = {
        header: title
      }

      let fieldArr: Array<FormItemOptionInterface> = []

      let group: FormGroupInterface = {
        option: groupOption,
        children: fieldArr
      };

      fields.forEach(field => {
        let type = field['type'] as string;
        let optionArr: Array<SelectOptionInterface> = [];
        if (type == 'select') {
          let options = field['options'] as Array<object>
          optionArr = options.map(option => {
            return {
              label: option['label'],
              value: option['value']
            } as SelectOptionInterface
          })
        }

        fieldArr.push({
          key: field['key'],
          label: field['label'],
          type: field['type'] ?? FormItemType.input,
          readOnly: field['readOnly'],
          disable: field['disable'],
          options: optionArr
        })
      })
      this.globalOptionFormGroups.push(group);
    })

  };
  loadTaskOptionsJson(json: string) {
    let jsonMap = JSONUtil.jsonToMap(json);
    let arr = jsonMap.get('taskOptionFields') as Array<object>;
    arr.forEach(item => {

      let title = item['title'] as string;
      let fields = item['fields'] as Array<object>

      let groupOption: FormGroupOptionInterface = {
        header: title
      }

      let fieldArr: Array<FormItemOptionInterface> = []

      let group: FormGroupInterface = {
        option: groupOption,
        children: fieldArr
      };

      fields.forEach(field => {
        let type = field['type'] as string;
        let optionArr: Array<SelectOptionInterface> = [];
        if (type == 'select') {
          let options = field['options'] as Array<object>
          optionArr = options.map(option => {
            return {
              label: option['label'],
              value: option['value']
            } as SelectOptionInterface
          })
        }

        fieldArr.push({
          key: field['key'],
          label: field['label'],
          type: field['type'] ?? FormItemType.input,
          readOnly: field['readOnly'],
          disable: field['disable'],
          options: optionArr
        })
      })
      this.taskOptionFormGroups.push(group);
    })

  };

  private constructor() {
  }
}

