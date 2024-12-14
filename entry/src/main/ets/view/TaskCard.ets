import Aria2 from '../model/Aria2';
import { Task, TaskStatus } from '../model/Task';
import RpcService from '../service/RpcService';
import { Aria2Keys } from '../static/PersistentKeys';
import CommonUtils from '../utils/CommonUtils';
import MyWave, { ProcessDirection } from './MyWave';
import { ScaleSymbolGlyph } from './ScaleSymbleGlyph';
import { router } from '@kit.ArkUI';

@Component
export struct TaskCard {
  @Prop @Require task: Task;
  @StorageProp(Aria2Keys.DEFAULT) defaultAria2: Aria2 | undefined = undefined;

  build() {
    Stack() {
      if (this.task.status == TaskStatus.active) {
        MyWave({
          title: ' ',
          percent: (this.task.computedPercentage() ?? 0) / 100,
          option: {
            duration: 500,
            direction: ProcessDirection.right
          },
          contentString: " "
        }).width('100%')
      }
      Column() {
        Row() {
          Text(this.task.taskName).fontSize(25).textOverflow({
            overflow: TextOverflow.Ellipsis
          }).maxLines(1).width('80%').margin(5)
          Blank()
          this.buildActions()
        }.width('100%').height('20%').justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Bottom)

        Row() {
          Column({space:5}) {
            if (this.task.status != TaskStatus.active) {
              Row() {
                Text(this.task.getUri()).textOverflow({
                  overflow: TextOverflow.Ellipsis
                }).maxLines(1).margin({ bottom: 20, left: 10 }).fontColor(Color.Gray)
              }

            }
            if (this.task.status == TaskStatus.active) {
              Row() {
                Row({ space: 5 }) {
                  Image($r('app.media.data')).size({ width: 18, height: 18 })
                  Text(CommonUtils.formatBytes(this.task.totalLength))
                }

                Row({ space: 5 }) {
                  Text(this.task.computedPercentageString())
                }
              }.justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Bottom).width('100%')
            }
            Progress({
              value: this.task.computedPercentage(),
              total: 100,
              type: ProgressType.Linear,
            }).color($r('app.color.active_color'))
          }
        }.width('100%').height('50%').alignItems(VerticalAlign.Bottom)

        Row() {
          if (this.task.status == TaskStatus.active) {
            Row({ space: 5 }) {
              Image($r('app.media.download')).size({ width: 18, height: 18 })
              Text(CommonUtils.formatBytes(this.task.downloadSpeed) + "/s")
            }.justifyContent(FlexAlign.Start)

            Row({space:5}) {
              Text(this.task.getRemainTime())
              Image($r('app.media.clock')).size({ width: 18, height: 18 })
            }
          }else {
            Row() {
              Row({ space: 5 }) {
                Image($r('app.media.data')).size({ width: 18, height: 18 })
                Text(CommonUtils.formatBytes(this.task.totalLength))
              }

              Row({ space: 5 }) {
                Text(this.task.computedPercentageString())
              }
            }.justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Bottom).width('100%')
          }
        }.width('100%').height('30%').justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Bottom)
      }.padding(5)

    }
    .shadow(1)
    .borderRadius(10)
    .margin(1)
    .width('100%')
    .height('90%')
    .backgroundColor($r('app.color.card_background_color'))
  }

  @
  Builder
  buildActions() {
    Row({ space: 5 }) {
      Image($r('app.media.information')).fillColor($r('app.color.active_color')).clickEffect({
        level:ClickEffectLevel.LIGHT,
        scale:0.5
      }).onClick(()=>{
        router.pushUrl({ url: "pages/taskDetailPage", params: this.task })
      }).size({
        width:20,
        height:20
      })
      // if (this.task.status == TaskStatus.active) {
      //   ScaleSymbolGlyph({
      //     source: $r('sys.symbol.pause'),
      //     fontSize: 20
      //   }).onClick(() => {
      //     this.defaultAria2 && RpcService.pauseTask(this.defaultAria2, this.task.gid!)
      //   })
      // } else if (this.task.status == TaskStatus.paused) {
      //   ScaleSymbolGlyph({
      //     source: $r('sys.symbol.play'),
      //     fontSize: 20
      //   }).onClick(() => {
      //     this.defaultAria2 && RpcService.unpauseTask(this.defaultAria2, this.task.gid!)
      //   })
      // } else if (this.task.status == TaskStatus.removed || this.task.status == TaskStatus.error) {
      //   ScaleSymbolGlyph({
      //     source: $r('sys.symbol.arrow_clockwise'),
      //     fontSize: 20
      //
      //   }).onClick(() => {
      //     // this.defaultAria2 && RpcService.createTask(this.defaultAria2,[])
      //   })
      // }
    }.margin({ right: 10 })
  }
}