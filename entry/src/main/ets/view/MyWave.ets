import { FrameNode, NodeController, RenderNode, ShapeClip } from '@kit.ArkUI';
import { drawing } from '@kit.ArkGraphics2D';
import { AnimatedProp } from './AnimtionedWidget';
import { nothingToBuild } from '../utils/UIUtil';

export enum ProcessDirection {
  top,
  bottom,
  left,
  right
}

export enum WaveDirection {
  ltr, rtl
}

class WaveRenderNode extends RenderNode {
  waveOption: WaveOptionInterface
  percent: number;
  angle: number;

  constructor(waveOption: WaveOptionInterface, percent: number, angle: number) {
    super();
    this.waveOption = waveOption;
    this.percent = percent;
    this.angle = angle;
  }

  async draw(context: DrawContext) {
    let maxWidth = vp2px(this.waveOption.width);
    let maxHeight = vp2px(this.waveOption.height);

    const canvas = context.canvas

    const pathPen = new drawing.Pen()

    pathPen.setColor(
      {
        alpha: 0,
        red: 255,
        green: 255,
        blue: 255
      })

    // 创建一个画刷Brush对象，Brush对象用于形状的填充
    let pathBrush = new drawing.Brush()

    if (AppStorage.get<number>('themeMode') == 1) {
      pathBrush.setColor({
        alpha: 100,
        red: 100,
        blue: 237,
        green: 149
      })
    } else {
      pathBrush.setColor({
        alpha: 100,
        red: 255,
        blue: 0,
        green: 127
      })
    }


    let path = new drawing.Path()

    let baseLen =
      this.waveOption.direction == ProcessDirection.top || this.waveOption.direction == ProcessDirection.bottom ?
        maxHeight : maxWidth;
    let percentLen = baseLen * this.percent;

    if (this.waveOption.direction == ProcessDirection.top) {
      path.moveTo(0, maxHeight)
      for (let i = 0; i < maxWidth; i++) {
        let val = Math.sin(this.angle + (i / maxWidth) * 2 * Math.PI) * this.waveOption.amplitude!;
        path.lineTo(i, maxHeight - (percentLen + val))
      }
      path.lineTo(maxWidth, maxHeight);
      path.lineTo(0, maxHeight)
    }

    if (this.waveOption.direction == ProcessDirection.bottom) {
      for (let i = 0; i < maxWidth; i++) {
        let val = Math.sin(this.angle + (i / maxWidth) * 2 * Math.PI) * this.waveOption.amplitude!;
        path.lineTo(i, percentLen + val)
      }
      path.lineTo(maxWidth, 0);
      path.lineTo(0, 0)
    }
    if (this.waveOption.direction == ProcessDirection.left) {
      path.moveTo(maxWidth, 0)
      for (let i = 0; i < maxHeight; i++) {
        let val = Math.sin(this.angle + (i / maxHeight) * 2 * Math.PI) * this.waveOption.amplitude!;
        path.lineTo(maxWidth - (percentLen + val), i)
      }
      path.lineTo(maxWidth, maxHeight);
      path.lineTo(maxWidth, 0);
    }
    if (this.waveOption.direction == ProcessDirection.right) {
      for (let i = 0; i < maxHeight; i++) {
        let val = Math.sin(this.angle + (i / maxHeight) * 2 * Math.PI) * this.waveOption.amplitude!;
        path.lineTo(percentLen + val, i)
      }

      path.lineTo(0, maxHeight);
      path.lineTo(0, 0)

    }

    // 将Brush画刷设置到canvas中
    canvas.attachBrush(pathBrush)
    canvas.attachPen(pathPen)
    canvas.drawPath(path);


  }
}


class MyWaveNodeController extends NodeController {
  waveOption: WaveOptionInterface
  private angle: number;
  private step: number = 0.1
  private timer?: number;

  constructor(waveOption?: WaveOptionInterface) {
    super();
    this.waveOption = {
      width: waveOption?.width ?? 0,
      height: waveOption?.height ?? 0,
      duration: waveOption?.duration ?? 950,
      direction: waveOption?.direction ?? ProcessDirection.top,
      waveDirection: waveOption?.waveDirection ?? WaveDirection.ltr,
      amplitude: waveOption?.amplitude ?? 20,
    };
    if (this.waveOption.waveDirection == WaveDirection.ltr) {
      this.angle = 2 * Math.PI;
    } else {
      this.angle = 0;
    }
  }

  updatePercent(percent: number) {
    this.percent = percent;
    this.rebuild()
  }

  aboutToAppear(): void {
    this.timer = setInterval(() => {
      if (this.waveOption.waveDirection == WaveDirection.ltr) {
        if (this.angle <= 0) {
          this.angle = 2 * Math.PI
        }
        this.step = -Math.abs(this.step)
      } else {
        if (this.angle >= 2 * Math.PI) {
          this.angle = 0
        }
        this.step = Math.abs(this.step)
      }
      this.angle = this.angle + this.step;
      this.rebuild();
    }, 20)
  }

  aboutToDisappear(): void {
    this.timer && clearInterval(this.timer)
  }

  private rootNode: FrameNode | null = null;
  private percent: number = 0;

  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext)
    let maxWidth = this.waveOption.width as number;
    let maxHeight = this.waveOption.height as number;

    if (this.rootNode == null) {
      return this.rootNode
    }

    const renderNode = this.rootNode.getRenderNode()

    if (renderNode != null) {
      renderNode.frame = {
        x: 0,
        y: 0,
        width: maxWidth,
        height: maxHeight
      }
      const clip = new ShapeClip();
      let corner = vp2px(10)
      clip.setRoundRectShape({
        rect: {
          left: 0,
          top: 0,
          right: vp2px(maxWidth),
          bottom: vp2px(maxHeight)
        },
        corners: {
          topLeft: { x: corner, y: corner },
          topRight: { x: corner, y: corner },
          bottomLeft: { x: corner, y: corner },
          bottomRight: { x: corner, y: corner },
        }
      })
      renderNode.shapeClip = clip;
      // 创建一个RectRenderNode对象
      const rectNode = new WaveRenderNode(this.waveOption, this.percent, this.angle)
      // 定义rectNode的像素格式
      rectNode.frame = {
        x: 0,
        y: 0,
        width: maxWidth,
        height: maxHeight
      }
      // rectNode.scale = { x: 1, y: 1 }

      renderNode.appendChild(rectNode)
    }

    return this.rootNode
  }

  changeSize(size: SizeOptions) {
    this.waveOption.width = size.width as number;
    this.waveOption.height = size.height as number;
    this.rebuild();
  }
}


interface WaveOptionInterface {
  width?: number
  height?: number
  duration?: number
  //进度方向
  direction?: ProcessDirection
  //波运动方向
  waveDirection?: WaveDirection
  //振幅
  amplitude?: number


}


@Component
export default struct MyWave {
  private oldPercent: number = 0
  private nodeController?: MyWaveNodeController;
  private animate?: AnimatedProp<number>;
  @Prop option: WaveOptionInterface
  @Prop @Watch('updatePercent') percent: number
  @Prop contentString: string;
  @Prop title: Resource | string
  @Prop titleAlignRule: AlignRuleOption
  @BuilderParam child: () => void = nothingToBuild;

  @Builder
  defaultContent() {
    Text((this.percent * 100).toFixed(2) + " %")
  }

  aboutToAppear(): void {
    this.oldPercent = this.percent
    this.nodeController = new MyWaveNodeController(this.option);
  }

  build() {
    Stack() {
      NodeContainer(this.nodeController).align(Alignment.Center)
      RelativeContainer() {
        Text(this.title).margin(10).alignRules(this.titleAlignRule).fontSize(15)
        Text(this.contentString ?? (this.percent * 100).toFixed(2) + " %").alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          center: { anchor: '__container__', align: VerticalAlign.Center }
        })
      }.width('100%').height('100%')

    }
    .width(this.option?.width ?? '100%')
    .height(this.option?.height ?? '100%')
    .onSizeChange((oldValue, newValue) => {
      this.nodeController?.changeSize(newValue);
    })
    .backgroundColor($r('app.color.card_background_color'))
    .borderRadius(10)

  }

  updatePercent(changedPropertyName: string) {
    if (this.oldPercent != this.percent) {
      let from = this.oldPercent;
      let to = this.percent;
      this.animate = new AnimatedProp<number>({
        animatorOptions: {
          duration: this.option?.duration ? this.option.duration - 50 : 950,
          easing: "linear",
          delay: 0,
          fill: "forwards",
          direction: "normal",
          iterations: 1,
          begin: from,
          end: to
        },
        initial: 0,
        valueMapper: (process, oldValue) => {
          return process;
        }
      })
      this.animate.onFrame((process) => {
        this.nodeController?.updatePercent(process)
      })
      this.animate.onFinish(() => {
        this.oldPercent = to
      })
      this.animate.play();
    }
  }
}