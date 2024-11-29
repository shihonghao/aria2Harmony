import { FrameNode, NodeController, RectShape, RenderNode } from '@kit.ArkUI';
import { common2D, drawing } from '@kit.ArkGraphics2D';
import { AnimatedProp } from './AnimtionedWidget';
import UIUtil, { nothingToBuild } from '../utils/UIUtil';

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
    const pen = new drawing.Pen()
    pen.setStrokeWidth(5)
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 255,
      blue: 255
    })

    canvas.attachPen(pen)

    let rrect = new drawing.RoundRect({
      left: 0,
      right: maxWidth,
      top: 0,
      bottom: maxHeight
    }, 10, 10);


    canvas.drawRoundRect(rrect)

    canvas.save();

    canvas.restore();


    // 创建一个画刷Brush对象，Brush对象用于形状的填充
    let brush = new drawing.Brush()
    // let brush_color: common2D.Color = {
    //   alpha: 0xFF,
    //   red: 0x00,
    //   green: 0xFF,
    //   blue: 0x00
    // }
    brush.setMaskFilter(drawing.MaskFilter.createBlurMaskFilter(drawing.BlurType.NORMAL, 10))
    brush.setColor({
      alpha: 200,
      red: 255,
      green: 200,
      blue: 255
    })

    // 将Brush画刷设置到canvas中
    canvas.attachBrush(brush)


    let path = new drawing.Path()

    let baseLen =
      this.waveOption.direction == ProcessDirection.top || this.waveOption.direction == ProcessDirection.bottom ?
        maxHeight : maxWidth;
    let percentLen = baseLen * this.percent;

    if (this.waveOption.direction == ProcessDirection.top) {
      path.moveTo(0, maxHeight - 10)
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
      amplitude: waveOption?.amplitude ?? 20
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
      // 创建一个RectRenderNode对象
      const rectNode = new WaveRenderNode(this.waveOption, this.percent, this.angle)
      // 定义rectNode的像素格式
      rectNode.frame = {
        x: 0,
        y: 0,
        width: maxWidth,
        height: maxHeight
      }
      // rectNode.pivot = { x: 0.2, y: 0.8 }
      rectNode.scale = { x: 1, y: 1 }

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
  @Prop title: string
  @Prop titleAlignRule: AlignRuleOption

  @BuilderParam child:()=>void = nothingToBuild;


  @Builder
  defaultContent() {
    Text((this.percent * 100).toFixed(2) + " %")
  }

  aboutToAppear(): void {
    this.oldPercent = this.percent
    this.nodeController = new MyWaveNodeController(this.option);
  }

  build() {
    RelativeContainer() {
      NodeContainer(this.nodeController).align(Alignment.Center)
      Text(this.title).margin(10).alignRules(this.titleAlignRule).fontSize(15)
      Text(this.contentString ?? (this.percent * 100).toFixed(2) + " %").alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        center: { anchor: '__container__', align: VerticalAlign.Center }
      })
    }.width(this.option?.width ?? '100%').height(this.option?.height ?? '100%').onSizeChange((oldValue, newValue) => {
      this.nodeController?.changeSize(newValue);
    })

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