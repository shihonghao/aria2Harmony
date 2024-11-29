export  enum PromiseStatus {
  processing,
  finish,
  error
}

interface PromiseWrapper<T> {
  promise: Promise<T>;
  onData?: (data: T) => void;
}

@Component
export struct PromiseBuilder {
  @Require @Prop promiseWrapper: PromiseWrapper<object>;
  @State status: PromiseStatus = PromiseStatus.processing;
  private data?: object;

  aboutToAppear(): void {
    this.promiseWrapper.promise.then((data) => {
      this.status = PromiseStatus.finish;
      this.promiseWrapper.onData && this.promiseWrapper.onData(data);
      this.data = data;
    }).catch(() => {
      this.status = PromiseStatus.error;
    })
  }

  @BuilderParam finishBuilder: (data: object) => void;
  @BuilderParam processingBuilder: () => void;
  @BuilderParam errorBuilder: () => void;

  build() {
    if (this.status == PromiseStatus.finish) {
      this.finishBuilder(this.data!);
    } else if (this.status == PromiseStatus.processing) {
      this.processingBuilder();
    } else {
      this.errorBuilder();
    }
  }
}