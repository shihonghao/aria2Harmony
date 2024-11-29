interface ResultInterface<T> {
  data?: T;
  code?: string;
  message?: string
}

export default class Result<T> {
  success: boolean;
  data?: T;
  code?: string;
  message?: string;

  static ok<T>(data: T) {
    return new Result<T>(true, {
      data: data
    })
  }

  static error<T>(code: string, message: string) {
    return new Result<T>(true, {
      message: message,
      code: code
    })
  }

  private constructor(success: boolean, param?: ResultInterface<T>) {
    this.success = success;
    this.data = param?.data;
    this.message = param?.message;
    this.code = param?.code;
  }
}