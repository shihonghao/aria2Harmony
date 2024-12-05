import { Font, FrameNode, NodeController, RenderNode } from '@kit.ArkUI';
import { drawing } from '@kit.ArkGraphics2D';
import { DisplayUtil } from '@pura/harmony-utils';

interface PieceOptionInterface {
  bitfield: string;
  numPieces: number;
  itemWidth: number;
  itemMargin: number;
  canvasWidth: number;
  canvasHeight: number;
  canvasPadding: number;
}

class PieceRenderNode extends RenderNode {
  pieceOption: PieceOptionInterface

  constructor(pieceOption: PieceOptionInterface) {
    super();
    this.pieceOption = pieceOption;
  }

  async draw(context: DrawContext) {

    const canvas = context.canvas
    const pen = new drawing.Pen()
    pen.setStrokeWidth(5)
    pen.setColor({
      alpha: 255,
      red: 153,
      green: 153,
      blue: 153
    })

    canvas.attachPen(pen)

    // let rrect = new drawing.RoundRect({
    //   left: 0,
    //   right: maxWidth,
    //   top: 0,
    //   bottom: maxHeight
    // }, 10, 10);


    // canvas.drawRoundRect(rrect)

    canvas.save();

    canvas.restore();


    // 创建一个画刷Brush对象，Brush对象用于形状的填充
    let brush = new drawing.Brush()

    let len = this.pieceOption.itemWidth
    let piecesStatus = this.getPieceStatus(this.pieceOption.numPieces, this.pieceOption.bitfield);
    let interval = this.pieceOption.itemMargin;
    let posLeft = interval / 2;
    let posRight = len + posLeft;
    let posTop = interval / 2;
    let posBottom = len + posTop;


    for (let i = 0; i < this.pieceOption.numPieces; i++) {
      let status = piecesStatus[i];
      if (!status) {
        brush.setColor({
          alpha: 255,
          red: 204,
          green: 204,
          blue: 204
        })
        canvas.attachBrush(brush)
      } else {
        brush.setColor({
          alpha: 255,
          red: 255,
          green: 255,
          blue: 0
        })
        canvas.attachBrush(brush)
      }
      //Rect.fromLTWH(posX, posY, len * 0.8, len * 0.8), paint
      canvas.drawRect({
        left: posLeft,
        top: posTop,
        right: posRight,
        bottom: posBottom
      });


      posLeft = posRight + 1 / 2 * interval;

      if ((posLeft + 1 / 2 * interval + len) >= (this.pieceOption.canvasWidth + this.pieceOption.canvasPadding)) {
        posLeft = interval / 2;
        posRight = posLeft + len
        posTop = posTop + len + interval;
        posBottom = posTop + len
      } else {
        posLeft += 1 / 2 * interval;
        posRight = posLeft + len;
      }
    }


  }

  getCombinedPieces(bitField: string, pieceCount: number): Array<Map<String, boolean | number>> {
    let pieces = this.getPieceStatus(pieceCount, bitField);
    let combinedPieces: Map<string, boolean | number>[] = [];

    for (let i = 0; i < pieces.length; i++) {
      let isCompleted: boolean = pieces[i];

      if (combinedPieces.length > 0 &&
        (combinedPieces[combinedPieces.length -1])['isCompleted'] == isCompleted) {
        (combinedPieces[combinedPieces.length -1])['count'] =
          ((combinedPieces[combinedPieces.length -1])['count'] ?? 0) + 1;
      } else {
        combinedPieces.push(new Map<string, boolean | number>([
          ["isCompleted", isCompleted], ['count', 1]
        ]));
      }
    }

    return combinedPieces;
  }

  getPieceStatus(pieceCount: number, bitField?: string): Array<boolean> {
    if (pieceCount == 0) {
      return [];
    }

    let pieces: Array<boolean> = [];
    for (let i = 0; i < pieceCount; i++) {
      pieces.push(false)
    }

    if (bitField == null) {
      return pieces;
    }

    let pieceIndex = 0;

    for (let i = 0; i < bitField.length; i++) {
      let bitSet = parseInt(bitField[i], 16);

      for (let j = 1; j <= 4; j++) {
        let bit = (1 << (4 - j));
        let isCompleted = (bitSet & bit) === bit;

        pieces[pieceIndex++] = isCompleted;

        if (pieceIndex >= pieceCount) {
          return pieces;
        }
      }
    }

    return pieces;
  }
}


class MyPieceNodeController extends NodeController {
  pieceOption: PieceOptionInterface

  constructor(pieceOption: PieceOptionInterface) {
    super();
    this.pieceOption = pieceOption;
  }

  private rootNode?: FrameNode;

  aboutToAppear(): void {

  }

  aboutToDisappear(): void {
  }

  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext)

    if (this.rootNode == null) {
      return this.rootNode
    }

    const renderNode = this.rootNode.getRenderNode()

    if (renderNode != null) {
      renderNode.frame = {
        x: 0,
        y: 0,
        width: px2vp(this.pieceOption.canvasWidth),
        height: px2vp(this.pieceOption.canvasHeight)
      }
      // 创建一个RectRenderNode对象
      const rectNode = new PieceRenderNode(this.pieceOption)
      // 定义rectNode的像素格式
      rectNode.frame = {
        x: 0,
        y: 0,
        width: px2vp(this.pieceOption.canvasWidth),
        height: px2vp(this.pieceOption.canvasHeight)
      }
      rectNode.scale = { x: 1, y: 1 }
      renderNode.appendChild(rectNode)
    }
    return this.rootNode
  }
}

export class Piece {
  numPieces: number;
  bitfield: string;

  constructor(numPieces: number, bitfield: string) {
    this.numPieces = numPieces;
    this.bitfield = bitfield;
  }
}

export enum PieceInfoType {
  grid,
  bar
}

@Component
export default struct PieceInfoWidget {
  @Prop @Require piece: Piece
  @Prop @Require type: PieceInfoType
  private _height: number | string = '100%';
  private nodeController?: MyPieceNodeController;

  aboutToAppear(): void {
    let displayWidth = DisplayUtil.getWidth() - vp2px(40)
    let itemWidth = displayWidth / 20;
    let margin = itemWidth * 0.2;
    this._height = (itemWidth + margin) * (this.piece.numPieces / 20 + 1)
    this.nodeController = new MyPieceNodeController({
      numPieces: this.piece.numPieces,
      bitfield: this.piece.bitfield,
      itemWidth: itemWidth - margin,
      itemMargin: margin,
      canvasWidth: displayWidth,
      canvasHeight: this._height,
      canvasPadding: vp2px(20)
    });

  }

  build() {
    Scroll() {
      Column() {
        Row({space:10}){
          RelativeContainer().size({ width: 20, height: 20 }).border({
            width: 1
          }).backgroundColor(Color.Yellow)
          Text($r('app.string.complete'))
          RelativeContainer().size({ width: 20, height: 20 }).border({
            width: 1

          }).backgroundColor('#cccccc')
          Text($r('app.string.unComplete'))

        }

        NodeContainer(this.nodeController).height(this._height + 'px').padding(20)
      }
    }
  }
}