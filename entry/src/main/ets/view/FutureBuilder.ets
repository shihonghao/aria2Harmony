enum FutureStatus {
  processing,
  finish,
  error
}

@Component
export struct FutureBuilder {
  @State status: FutureStatus = FutureStatus.processing;
  @Require promise?: Promise<boolean>;
  onFinish?: () => void;
  onError?: () => void;

  aboutToAppear(): void {
    this.promise!.then(() => {
      this.status = FutureStatus.finish;
      this.onFinish && this.onFinish();
    }).catch(() => {
      this.status = FutureStatus.error;
      this.onError && this.onError();
    })
  }

  @BuilderParam finishBuilder: () => void;
  @BuilderParam processingBuilder: () => void;
  @BuilderParam errorBuilder: () => void;

  build() {
    Column() {
      if (this.status == FutureStatus.finish) {
        this.buildFinish();
      } else if (this.status == FutureStatus.processing) {
        this.buildProcessing();
      } else {
        this.buildError();
      }
    }.transition(TransitionEffect.SLIDE).height('100%').width('100%')
  }

  @Builder
  buildFinish() {

    this.finishBuilder()

  }

  @Builder
  buildError() {
    this.errorBuilder()

  }

  @Builder
  buildProcessing() {
    this.processingBuilder()
  }
}