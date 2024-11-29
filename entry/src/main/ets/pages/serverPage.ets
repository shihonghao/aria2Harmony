import { ServerCard } from '../view/ServerCard';
import Aria2 from '../model/Aria2';
import { Aria2Keys } from '../static/PersistentKeys';
import { OhosSmartDialog } from 'ohos_smart_dialog';
import ServerEditSheet from '../view/ServerEditSheet';
import MyTransitionEffects from '../effects/MyTransitionEffects';
import { AnimatedIcon } from '../view/AnimatedIcon';
import { router, SymbolGlyphModifier } from '@kit.ArkUI';
import ComponentRef from '../view/ComponentRef';


@Entry
@Component
struct ServerPage {
  @Watch('updateTitle') @StorageProp(Aria2Keys.DEFAULT) defaultAria2: Aria2 | undefined = undefined;
  @StorageProp(Aria2Keys.ARIA2S) aria2s: Map<string, Aria2> = new Map();
  title: string = "Please add an Aria2";
  @State toggle: boolean = false;
  _opacity: number = 0.5;
  serverEditSheetRef = ComponentRef.useRef<ServerEditSheet>();

  onPageShow(): void {
    this.updateTitle('');
  }

  build() {
    Stack() {
      Navigation() {
        ServerEditSheet({
          serverEditSheetRef: this.serverEditSheetRef
        })
        if (this.aria2s.size > 0) {
          Scroll() {
            Column() {
              Swiper() {
                ForEach(this.getAria2List(), (item: Aria2, index: number) => {
                  ServerCard({ aria2: item })
                    .margin({
                      left: 20,
                      right: 20,
                      top: 5,
                      bottom: 10
                    })
                })
              }.loop(false).indicator(false)

            }
          }
        } else {
          Stack() {
            Button("add")
              .width('80%')
              .borderRadius(1).onClick(() => {
              this.serverEditSheetRef.value?.open();
            })

          }.position({ x: '50%', y: '40%' }).markAnchor({ x: '50%' })

        }
      }
      .menus(this.buildMenus())
      .title(this.buildTitle())
      .titleMode(NavigationTitleMode.Full)
      .hideBackButton(true)

      OhosSmartDialog()

    }
  }

  getAria2List(): Array<Aria2> {
    let aria2List: Array<Aria2> = [];
    this.aria2s.forEach((aria2) => {
      aria2List.push(aria2);
    })

    return aria2List;

  }

  @Builder
  buildSheet() {
    ServerEditSheet()
  }

  @Builder
  buildTitle() {
    if (this.toggle) {
      Text(this.title)
        .margin({ left: 20, top: 10 })
        .fontSize(30)
        .fontWeight(5)
        .transition(MyTransitionEffects.OPACITY_SLIDE_START)
    } else {
      Text(this.title)
        .margin({ left: 20, top: 10 })
        .fontSize(30)
        .fontWeight(5)
        .transition(MyTransitionEffects.OPACITY_SLIDE_START)
    }
  }

  @Builder
  buildMenus() {
    Row() {

      AnimatedIcon({
        icon: $r('app.media.Aria2'),
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
      })
        .size({ width: 40, height: 40 }).bindMenu([
        {
          symbolIcon: new SymbolGlyphModifier($r('sys.symbol.streak_jump')),
          value: "去任务",
          action: () => {
            router.pushUrl({
              url: "pages/taskPage"
            })
          }
        },
        {
          symbolIcon: new SymbolGlyphModifier($r('sys.symbol.plus')),
          value: "新增",
          action: () => {
            this.serverEditSheetRef.value?.open();

          }
        }
      ])
    }.margin(20)
  }

  updateTitle(propName: string) {
    let oriTitle = this.title;
    if (this.aria2s.size == 0) {
      this.title = "Please add an Aria2"
    } else if (this.defaultAria2?.name) {
      this.title = this.defaultAria2.name;
    } else {
      this.title = "Please selected Aria2"
    }
    if (this.title != oriTitle) {
      this.toggle = !this.toggle;
    }
  }
}