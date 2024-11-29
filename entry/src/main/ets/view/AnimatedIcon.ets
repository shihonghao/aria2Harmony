import { AnimatedProp, AnimatedPropInterface, TriggerMode } from './AnimtionedWidget';

export  interface scaleAnimatedIconInterface {
  onClick?: () => void;
  fillColor?: ResourceColor;
  size?: SizeOptions;
}

@Builder
export function scaleAnimatedIcon(icon: Resource,
  param?: scaleAnimatedIconInterface) {
  AnimatedIcon({
    icon: icon,
    iconSize: param?.size,
    fillColor: param?.fillColor,
    scaleProp: {
      animatorOptions: {
        duration: 200,
        easing: "linear",
        delay: 0,
        fill: "forwards",
        direction: "alternate",
        iterations: 2,
        begin: 1,
        end: 0.5
      },
      initial: { x: 1, y: 1 },
      valueMapper: (data) => {
        return { x: data, y: data }
      }
    }
  }).onClick(() => {
    param?.onClick && param.onClick();
  })
}


@Component
export struct AnimatedIcon {
  @Require @Prop icon: Resource
  @Prop scaleProp: AnimatedPropInterface<ScaleOptions>;
  @Prop opacityProp: AnimatedPropInterface<number>;
  @Prop rotateProp: AnimatedPropInterface<RotateOptions>;
  @Prop fillColor: ResourceColor;
  @Prop iconSize: SizeOptions;
  @State
  private scaleAnimation?: AnimatedProp<ScaleOptions> = undefined;
  @State
  private opacityAnimation?: AnimatedProp<number> = undefined;
  @State
  private rotateAnimation?: AnimatedProp<RotateOptions> = undefined;
  private intervalList: Array<number> = [];

  aboutToAppear(): void {
    this.bindAnimation();
  }

  bindAnimation() {

    if (this.scaleProp) {
      this.scaleAnimation = new AnimatedProp(this.scaleProp);
      this.scaleAnimation.onFrame((process) => {
        this.scaleAnimation!.value = this.scaleAnimation!.convertValue(process);
      })
    }

    if (this.opacityProp) {
      this.opacityAnimation = new AnimatedProp(this.opacityProp);
      this.opacityAnimation.onFrame((process) => {
        this.opacityAnimation!.value = this.opacityAnimation!.convertValue(process);
      })
    }

    if (this.rotateProp) {
      this.rotateAnimation = new AnimatedProp(this.rotateProp);
      this.rotateAnimation.onFrame((process) => {
        this.rotateAnimation!.value = this.rotateAnimation!.convertValue(process);
      })
    }
  };

  build() {
    Image(this.icon)
      .onTouch((event) => {
        if (event.type == TouchType.Down) {
          this.doAnimation(TriggerMode.click)
        }
      })
      .onAppear(() => {
        this.doAnimation(TriggerMode.auto)
      })
      .fillColor(this.fillColor)
      .opacity(this.opacityAnimation?.value)
      .scale(this.scaleAnimation?.value)
      .rotate(this.rotateAnimation?.value)
      .hitTestBehavior(HitTestMode.Transparent)
      .size(this.iconSize)
  }

  doAnimation(triggerMode: TriggerMode) {
    this.doPropAnimation(triggerMode, this.scaleAnimation)
    this.doPropAnimation(triggerMode, this.opacityAnimation)
    this.doPropAnimation(triggerMode, this.rotateAnimation)
  }

  doPropAnimation<T>(triggerMode: TriggerMode, propAnimation?: AnimatedProp<T>) {
    if (propAnimation && propAnimation.getTriggerMode() == triggerMode) {
      propAnimation.play();
      if (propAnimation.isRepeat()) {
        this.intervalList.push(setInterval(() => {
          propAnimation.play();
        }, propAnimation.duration()))
      }

    }
  }

  aboutToDisappear(): void {
    this.intervalList.forEach((id) => {
      clearInterval(id);
    })
    this.intervalList = [];
  }
}

