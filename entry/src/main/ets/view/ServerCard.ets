import Aria2 from '../model/Aria2';
import RpcService from '../service/RpcService';
import { Aria2Keys } from '../static/PersistentKeys';
import { ServerState, ServerViewModel } from '../viewModel/ServerViewModel';
import { AnimatedIcon } from './AnimatedIcon';
import { router } from '@kit.ArkUI';
import { Aria2Utils } from '../utils/Aria2Utils';
import ServerEditSheet from './sheet/ServerEditSheet';
import ComponentRef from './ComponentRef';
import "reflect-metadata";
import MyWave, { ProcessDirection } from './MyWave';
import CommonUtils from '../utils/CommonUtils';


@Preview
@Component
export struct ServerCard {
  @Prop aria2: Aria2;
  @State model: ServerViewModel = new ServerViewModel();
  @Watch('updateSelectedAria2') @StorageLink(Aria2Keys.DEFAULT) defaultAria2: Aria2 | undefined = undefined;
  serverEditSheetRef = ComponentRef.useRef<ServerEditSheet>();
  private timer?: number;

  aboutToAppear(): void {
    this.model.selectedIconColor =
      this.aria2.isDefault ? $r('app.color.active_color') : $r('app.color.inactive_color');
    if(this.aria2.isDefault){
      this.tryConnect().then(()=>{
        this.startTimer()
      })
    }
  }

  aboutToDisappear(): void {
    this.timer ?? clearInterval(this.timer)
  }

  startTimer() {
    if (this.aria2.isDefault) {
      this.timer = setInterval(() => {
        RpcService.getGlobalStatus(this.aria2).then((globalStatus) => {
          this.model.updateGlobalStatus(globalStatus)
        })
      }, 1000)
    }
  }

  @Builder
  buildServerStateIcon() {
    if (this.model.state == ServerState.connecting) {
      Image($r("app.media.window_icon"))
        .size({ width: 100, height: 100 })
        .rotate({ angle: this.model.rotateAngle })
        .onAppear(() => {
          animateTo({
            duration: 200,
            iterations: -1
          }, () => {
            this.model.rotateAngle += 360
          })
        }).fillColor($r('app.color.active_color'))
    } else if (this.model.state == ServerState.connected) {
      Image($r("app.media.wifi_line")).opacity(0.2).fillColor(Color.Blue)
        .size({ width: 100, height: 100 }).fillColor($r('app.color.active_color'))
    } else if (this.model.state == ServerState.disconnected) {
      Image($r("app.media.wifi_off_line")).opacity(0.2)
        .size({ width: 100, height: 100 })
    } else if (this.model.state == ServerState.monitoring) {
      Image($r("app.media.wifi_line")).opacity(0.2).fillColor(Color.Blue)
        .size({ width: 100, height: 100 })
    } else if (this.model.state == ServerState.error) {
      Image($r("app.media.wifi_off_line")).opacity(0.2)
        .size({ width: 100, height: 100 })
    }
  }

  build() {
    Column() {
      Stack() {
        ServerEditSheet({
          aria2: this.aria2, serverEditSheetRef: this.serverEditSheetRef
        })
        this.buildServerStateIcon()
        Text(this.aria2.name).position({ left: 20, bottom: 20 }).fontSize(30)
        AnimatedIcon({
          icon: $r('app.media.more_1'),
          fillColor: $r('app.color.active_color'),
          rotateProp: {
            animatorOptions: {
              duration: 200,
              easing: "linear",
              delay: 0,
              fill: "forwards",
              direction: "alternate",
              iterations: 1,
              begin: 0,
              end: 360
            },
            initial: { angle: 0 },
            valueMapper: (data, oldValue) => {
              return { angle: data }
            }
          },
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
        }).position({ top: 10, right: 15 })
          .size({ width: 30, height: 30 })
          .bindMenu([
            {
              value: $r('app.string.edit'),
              action: () => {
                this.serverEditSheetRef.value?.open();
              },
              icon: $r('app.media.edit')
            },
            {
              value: $r('app.string.refresh'),
              action: () => {
                this.tryConnect();
              },
              icon: $r('app.media.refresh')
            },
            {
              value: $r('app.string.info'),
              action: () => {
                router.pushUrl({
                  url: "pages/globalOptionsPage",
                  params: this.aria2
                })
              },
              icon: $r('app.media.information')
            },
            {
              value: $r('app.string.delete'),
              action: () => {
                Aria2Utils.removeAria2(this.aria2);
              },
              icon: $r('app.media.delete')
            }
          ]);

        AnimatedIcon({
          icon: $r('app.media.check'),
          fillColor: this.model.selectedIconColor,
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
        }).position({ top: 10, left: 15 })
          .size({ width: 30, height: 30 })
          .onClick(() => {
            if (this.aria2.isDefault) {
              return;
            }
            this.tryConnect();
          })
        // AnimatedIcon({
        //   icon: $r('app.media.setting_1'),
        //   fillColor: $r('app.color.active_color'),
        //   scaleProp: {
        //     animatorOptions: {
        //       duration: 200,
        //       easing: "linear",
        //       delay: 0,
        //       fill: "forwards",
        //       direction: "alternate",
        //       iterations: 2,
        //       begin: 1,
        //       end: 0.5
        //     },
        //     initial: { x: 1, y: 1 },
        //     valueMapper: (data) => {
        //       return { x: data, y: data }
        //     }
        //   }
        // }).position({ right: 15, bottom: 15 })
        //   .size({ width: 30, height: 30 })
        //   .onClick(() => {
        //
        //   })


      }
      .borderRadius(20)
      .shadow(1)
      .backgroundColor($r('app.color.card_background_color'))
      .align(Alignment.Center)
      .height('48%')
      .width('100%')

      Column() {
        Row() {
          MyWave({
            title: $r('app.string.download_label'),
            percent: this.model.numActive / this.model.totalNum,
            option: {
              direction: ProcessDirection.top
            },
            contentString: this.model.numActive.toString()
          }).shadow(1).borderRadius(10).width('48%').height('100%')
          Column() {
            MyWave({
              title: $r('app.string.waiting_label'),
              percent: this.model.numWaiting / this.model.totalNum,
              option: {
                direction: ProcessDirection.left
              },
              contentString: this.model.numWaiting.toString()
            }).shadow(1).borderRadius(10).width('100%').height('48%')
            MyWave({
              title: $r('app.string.stopped_label'),
              percent: this.model.numStopped / this.model.totalNum,
              option: {
                direction: ProcessDirection.left
              },
              contentString: this.model.numStopped.toString()
            }).shadow(1).borderRadius(10).width('100%').height('48%')

          }.width('48%').height('100%').justifyContent(FlexAlign.SpaceBetween)
        }.justifyContent(FlexAlign.SpaceBetween).width('100%').height('48%')

        Column() {
          MyWave({
            title: $r('app.string.download_speed'),
            percent: this.model.downloadPercent,
            option: {
              duration: 500,
              direction: ProcessDirection.right
            },
            contentString: CommonUtils.formatBytes(this.model.currentDownloadSpeed) + "/s"
          }).shadow(1).borderRadius(10).width('100%').height('48%')

          MyWave({
            title: $r('app.string.upload_speed'),
            percent: this.model.uploadPercent,
            option: {
              duration: 500,
              direction: ProcessDirection.right
            },
            contentString: CommonUtils.formatBytes(this.model.currentUploadSpeed) + "/s"
          }).shadow(1).borderRadius(10).width('100%').height('48%')
        }.width('100%').height('48%').justifyContent(FlexAlign.SpaceBetween)

      }.height('48%').justifyContent(FlexAlign.SpaceBetween).margin({ top: 20 })

    }
  }

  tryConnect(): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      this.model.state = ServerState.connecting;
      setTimeout(() => {
        RpcService.connect(this.aria2).then(data => {
          this.model.state = ServerState.connected;
          this.defaultAria2 = this.aria2
          resolve();
        }).catch(() => {
          this.model.state = ServerState.error;
          reject();
        });
      }, 500)
    });
  }

  updateSelectedAria2(propName: string) {
    if (this.defaultAria2) {
      let isDefault = this.defaultAria2.key == this.aria2.key;
      if (this.aria2.isDefault != isDefault) {
        this.aria2.isDefault = isDefault;
        Aria2Utils.updateAria2(this.aria2).then(() => {
          this.model.selectedIconColor =
            this.aria2.isDefault ? $r('app.color.active_color') : $r('app.color.inactive_color');
          this.startTimer();
        })
      }
    }
  }
}
