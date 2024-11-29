import { Animator, AnimatorOptions, AnimatorResult } from '@kit.ArkUI';

// export enum AnimationStatus {
//   processing, Stopped
// }

export interface AnimatedPropInterface<T> {
  animatorOptions: AnimatorOptions;
  repeat?: boolean;
  triggerMode?: TriggerMode;
  initial: T;
  valueMapper: (process: number, oldValue?: T) => T
}

@Observed
export class AnimatedProp<T> {
  @Track
  value: T;
  private oldValue?: T;
  private valueConverter: (process: number, oldValue?: T) => T;
  private animatorOptions: AnimatorOptions
  private animator: AnimatorResult
  private animationStatus: AnimationStatus = AnimationStatus.Stopped;
  private repeat: boolean;
  private triggerMode: TriggerMode;

  constructor(param: AnimatedPropInterface<T>) {
    this.animatorOptions = param.animatorOptions;
    this.valueConverter = param.valueMapper;
    this.value = param.initial;
    this.oldValue = param.initial;
    this.animator = Animator.create(this.animatorOptions);
    this.animator.onFinish = () => {
      this.animationStatus = AnimationStatus.Stopped;
    }
    this.triggerMode = param.triggerMode ?? TriggerMode.click;
    this.repeat = param.repeat ?? false;
  }

  status(): AnimationStatus {
    return this.animationStatus;
  }

  isRepeat(): boolean {
    return this.repeat;
  }

  getTriggerMode(): TriggerMode {
    return this.triggerMode;
  }

  duration(): number {
    return this.animatorOptions.duration;
  }

  convertValue(data: number): T {
    this.oldValue = this.value;
    return this.valueConverter(data, this.oldValue)
  }


  onFrame(fn: (process: number) => void) {
    this.animator.onFrame = fn;
  }

  onFinish(fn: () => void) {
    this.animator.onFinish = () => {
      this.animationStatus = AnimationStatus.Stopped;
      fn();
    }
  }


  play(): void {
    if (this.animationStatus == AnimationStatus.Running) {
      return;
    }
    this.animationStatus = AnimationStatus.Running;
    this.animator.play();
  }

  pause(): void {
    if (this.animationStatus == AnimationStatus.Stopped) {
      return;
    }
    this.animator.pause();
    this.animationStatus = AnimationStatus.Stopped;
  }

  toggle(): void {
    if (this.animationStatus == AnimationStatus.Stopped) {
      this.play();
    } else {
      this.pause();
    }
  }
}


export enum TriggerMode {
  click,
  auto
}
