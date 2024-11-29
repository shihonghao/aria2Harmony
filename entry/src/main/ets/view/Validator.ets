
export default  class Validator {
  static NOT_NULL = (data: string): ValidateResult => {
    if (data) {
      return { success: true }
    } else {
      return { success: false, message: "* 不能为空" }

    }
  }
}

export interface ValidateResult {
  success: boolean;
  message?: string;
}
