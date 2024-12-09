import Aria2 from '../model/Aria2';
import { Task, TaskStatus } from '../model/Task';
import { Aria2Keys } from '../static/PersistentKeys';
import TaskViewModel from '../viewModel/TaskViewModel';
import { router, SymbolGlyphModifier } from '@kit.ArkUI';
import RpcService from '../service/RpcService';
import { AnimatedIcon } from '../view/AnimatedIcon';
import TaskEditSheet from '../view/sheet/TaskAddSheet';
import TaskAddSheet from '../view/sheet/TaskAddSheet';
import ComponentRef from '../view/ComponentRef';
import TypedTaskList from '../view/TypedTaskList';
import MyTransitionEffects from '../effects/MyTransitionEffects';

@Entry
@Component
struct TaskPage {
  @StorageProp(Aria2Keys.DEFAULT) defaultAria2: Aria2 | undefined = undefined;
  @State taskViewModel: TaskViewModel = new TaskViewModel();
  private taskListRefMap: Map<TaskStatus, ComponentRef<TypedTaskList>> = new Map([
    [TaskStatus.active, ComponentRef.useRef()],
    [TaskStatus.paused, ComponentRef.useRef()],
    [TaskStatus.waiting, ComponentRef.useRef()],
    [TaskStatus.removed, ComponentRef.useRef()],
    [TaskStatus.removed, ComponentRef.useRef()],
    [TaskStatus.complete, ComponentRef.useRef()],
  ]);
  taskAddSheetRef = ComponentRef.useRef<TaskAddSheet>();
  private timer?: number;




  aboutToAppear(): void {
    if (this.defaultAria2) {
      this.timer = setInterval(() => {
        let taskStatus = this.taskViewModel.taskStatus
        this.taskListRefMap.get(taskStatus)?.value?.fetchData();
      }, 1000)
    }
  }

  aboutToDisappear(): void {
    this.timer && clearInterval(this.timer)
  }

  @Builder
  buildMenus() {
    Row() {
      Blank()
      AnimatedIcon({
        icon: $r('app.media.Aria2'),
        fillColor: $r('app.color.active_color'),
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
        .size({ width: 40, height: 40 }).bindMenu(this.getActionMenu())
    }.padding({ left: 20, right: 20, top: 10 }).width('100%')
  }

  getActionMenu() {
    let menus: Array<MenuElement> = [
      {
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.streak_jump')),
        value: $r('app.string.go_servers'),
        action: () => {
          router.back()
        }
      },
      {
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.plus')),
        value: $r('app.string.add'),
        action: () => {
          this.taskAddSheetRef.value?.open();
        }
      },


    ];
    if (this.taskViewModel.taskStatus == TaskStatus.complete ||
      this.taskViewModel.taskStatus == TaskStatus.removed ||
      this.taskViewModel.taskStatus == TaskStatus.error
    ) {
      menus.push({
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.clean')),
        value: $r('app.string.clear'),
        action: () => {
          this.defaultAria2 && RpcService.purgeDownloadResult(this.defaultAria2);
        }
      },)
    } else if (this.taskViewModel.taskStatus == TaskStatus.active ||
      this.taskViewModel.taskStatus == TaskStatus.waiting) {
      menus.push({
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.pause')),
        value: $r('app.string.task_page_action_pause_all'),
        action: () => {
          this.defaultAria2 && RpcService.pauseAll(this.defaultAria2);
        }
      },)

    } else if (this.taskViewModel.taskStatus == TaskStatus.paused) {
      menus.push({
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.play')),
        value: $r('app.string.task_page_action_unpause_all'),
        action: () => {
          this.defaultAria2 && RpcService.unpauseAll(this.defaultAria2);
        }
      },)

    }
    return menus;
  }

  build() {

    Navigation() {
      TaskEditSheet({
        ref: this.taskAddSheetRef
      })
      Swiper(this.taskViewModel.swiperController) {
        TypedTaskList({ ref: this.taskListRefMap.get(TaskStatus.active),taskStatus:TaskStatus.active })
        TypedTaskList({ ref: this.taskListRefMap.get(TaskStatus.waiting),taskStatus:TaskStatus.waiting })
        TypedTaskList({ ref: this.taskListRefMap.get(TaskStatus.paused) ,taskStatus:TaskStatus.paused})
        TypedTaskList({ ref: this.taskListRefMap.get(TaskStatus.complete),taskStatus:TaskStatus.complete })
        TypedTaskList({ ref: this.taskListRefMap.get(TaskStatus.removed),taskStatus:TaskStatus.removed })
        TypedTaskList({ ref: this.taskListRefMap.get(TaskStatus.error),taskStatus:TaskStatus.error })
      }
      .loop(false)
      .indicator(false)
      .onChange((index) => {
      })
      .height('100%')
      .onAnimationStart((index, targetIndex) => {
        this.toggleTaskStatus(targetIndex)
      })

    }.title(this.buildTitle())
    .menus(this.buildMenus())
    .backButtonIcon($r('sys.media.ohos_ic_public_arrow_left')).titleMode(NavigationTitleMode.Free)

  }

  @Builder
  buildTitle() {
    Stack() {
      if (this.taskViewModel.toggle) {
        Text(this.taskViewModel.title)
          .fontWeight(FontWeight.Bolder)
          .fontSize(30)
          .margin(10)
          .transition(MyTransitionEffects.OPACITY_SLIDE_START)
      } else {
        Text(this.taskViewModel.title)
          .fontWeight(FontWeight.Bolder)
          .fontSize(30)
          .margin(10)
          .transition(MyTransitionEffects.OPACITY_SLIDE_START)

      }
    }.bindMenu([
      {
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.download')),
        value: $r('app.string.download_label'),
        action: () => {
          this.taskViewModel.toggleStatus(TaskStatus.active)
          this.taskViewModel.swiperController.changeIndex(0, true)
        }
      },
      {
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.timer')),
        value: $r('app.string.waiting_label'),
        action: () => {
          this.taskViewModel.toggleStatus(TaskStatus.waiting)
          this.taskViewModel.swiperController.changeIndex(1, true)
        }
      },
      {
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.pause')),
        value: $r('app.string.paused_label'),
        action: () => {
          this.taskViewModel.toggleStatus(TaskStatus.paused)
          this.taskViewModel.swiperController.changeIndex(2, true)
        }
      },
      {
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.flag_checkered')),
        value: $r('app.string.completed_label'),
        action: () => {
          this.taskViewModel.toggleStatus(TaskStatus.complete)
          this.taskViewModel.swiperController.changeIndex(3, true)
        }
      },
      {
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.trash')),
        value: $r('app.string.removed_label'),
        action: () => {
          this.taskViewModel.toggleStatus(TaskStatus.removed)
          this.taskViewModel.swiperController.changeIndex(4, true)
        }
      },
      {
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.warning')),
        value: $r('app.string.error_label'),
        action: () => {
          this.taskViewModel.toggleStatus(TaskStatus.error)
          this.taskViewModel.swiperController.changeIndex(5, true)
        }
      }
    ])

  }

  toggleTaskStatus(index: number | TaskStatus) {
    this.taskViewModel.toggleStatus(index);
  }
}