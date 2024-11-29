import MyTransitionEffects from '../effects/MyTransitionEffects';
import { AnimatedIcon } from './AnimatedIcon';
import { TriggerMode } from './AnimtionedWidget';
import { FutureBuilder } from './FutureBuilder';


@Component
export default struct LoadingWidget {
  @Prop failedMessage: string;
  @Prop successMessage: string;
  @Require promise?: Promise<boolean>;
  onFinish?: () => void;
  onError?: () => void;
  @BuilderParam finishBuilder: () => void = this.buildFinish;
  @BuilderParam processingBuilder: () => void = this.buildProcessing;
  @BuilderParam errorBuilder: () => void = this.buildError;

  @LocalBuilder
  buildFinish() {
    Column() {
      Image($r('app.media.check_1')).constraintSize({
        maxWidth: 60,
        maxHeight: 60
      })
      Text(this.successMessage).margin({top:20})
    }.position({ x: '50%', y: '50%' })
    .markAnchor({ x: '50%',y: '50%' }).transition(MyTransitionEffects.OPACITY)
  }

  @LocalBuilder
  buildError() {
    Column() {
      Image($r('app.media.error')).constraintSize({
        maxWidth: 100,
        maxHeight: 100
      }).constraintSize({
        maxWidth: 60,
        maxHeight: 60
      })
      Text(this.failedMessage).margin({top:20})
    }.position({ x: '50%', y: '50%' })
    .markAnchor({ x: '50%', }).transition(MyTransitionEffects.OPACITY)
  }

  @LocalBuilder
  buildProcessing() {
    Column() {
      AnimatedIcon({
        icon: $r('app.media.loading_1'),
        rotateProp: {
          triggerMode: TriggerMode.auto,
          animatorOptions: {
            duration: 3000,
            easing: "linear",
            delay: 0,
            fill: "forwards",
            direction: "normal",
            iterations: -1,
            begin: 0,
            end: 360
          },
          initial: {
            angle: 0
          },
          valueMapper: (data, oldValue) => {
            return { angle: data }
          }
        }
      }).constraintSize({
        maxWidth: 60,
        maxHeight: 60
      })
      Text("Loading...").margin({top:20})
    }.position({ x: '50%', y: '50%' })
    .markAnchor({ x: '50%',y: '50%' }).transition(MyTransitionEffects.OPACITY)

  }

  build() {
    Column() {
      FutureBuilder({
        promise: this.promise,
        finishBuilder: this.finishBuilder,
        processingBuilder: this.processingBuilder,
        errorBuilder: this.errorBuilder,
        onFinish: this.onFinish,
        onError: this.onError
      })

    }
    .width('100%')
    .height('100%')
  }
}