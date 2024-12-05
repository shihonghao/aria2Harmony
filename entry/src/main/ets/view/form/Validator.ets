
export default  class Validator {
  static NOT_NULL = (data: string): ValidateResult => {
    if (data) {
      return { success: true }
    } else {
      return { success: false, message: $r('app.string.validator_not_null') }

    }
  }
}

export interface ValidateResult {
  success: boolean;
  message?: string | Resource;
}
