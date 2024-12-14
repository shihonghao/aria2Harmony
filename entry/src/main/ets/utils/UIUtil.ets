import { promptAction } from '@kit.ArkUI';

export default class UIUtil {
  static showConfirmAlertDialog(message: Resource | string, title: Resource | string = $r('app.string.notice')) {
    promptAction.showDialog({
      title: title,
      message: message,
      isModal: true,
      buttons: [
        {
          text: $r('app.string.confirm'),
          primary: false ,
          color: $r('app.color.active_color')
        }
      ]
    })
  }
}

@Builder
export function nothingToBuild() {
}