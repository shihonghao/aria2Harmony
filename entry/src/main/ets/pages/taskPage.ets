import Aria2 from '../model/Aria2';
import { Task, TaskStatus } from '../model/Task';
import { Aria2Keys } from '../static/PersistentKeys';
import TaskViewModel from '../viewModel/TaskViewModel';
import { SymbolGlyphModifier } from '@kit.ArkUI';
import RpcService from '../service/RpcService';
import { TaskCard } from '../view/TaskCard';
import { PasteboardUtil } from '@pura/harmony-utils';
import { AnimatedIcon } from '../view/AnimatedIcon';
import TaskEditSheet from '../view/TaskAddSheet';
import ComponentRef from '../view/ComponentRef';
import TaskAddSheet from '../view/TaskAddSheet';
import MyTransitionEffects from '../effects/MyTransitionEffects';


interface GeneratedTypeLiteralInterface_1 {
  tasks: Array<Task>;
}

interface GeneratedTypeLiteralInterface_2 {
  task: Task;
}

@Entry
@Component
struct ServerPage {
  @StorageProp(Aria2Keys.DEFAULT) defaultAria2: Aria2 | undefined = undefined;
  @State taskViewModel: TaskViewModel = new TaskViewModel();
  @State activeTasks: Array<Task> = [];
  @State waitingTasks: Array<Task> = [];
  @State pausedTasks: Array<Task> = [];
  @State completeTasks: Array<Task> = [];
  @State removedTasks: Array<Task> = [];
  @State errorTasks: Array<Task> = [];
  taskAddSheetRef = ComponentRef.useRef<TaskAddSheet>();
  private timer?: number;

  getTaskListByStatus(status: TaskStatus): Array<Task> {
    switch (status) {
      case TaskStatus.active:
        return this.activeTasks;
      case TaskStatus.paused:
        return this.pausedTasks;
      case TaskStatus.complete:
        return this.completeTasks;
      case TaskStatus.waiting:
        return this.waitingTasks;
      case TaskStatus.error:
        return this.errorTasks;
      case TaskStatus.removed:
        return this.removedTasks;
    }
  }

  updateTasks(tasks: Array<Task>, taskStatus: TaskStatus) {

    if (taskStatus != this.taskViewModel.taskStatus) {
      return;
    }

    let targetList: Array<Task> = this.getTaskListByStatus(taskStatus);

    let removeArray = targetList.filter(o1 => tasks.findIndex(o2 => o1.gid == o2.gid) == -1)

    removeArray.forEach(task =>
    animateTo({ duration: 1000 }, () => {
      targetList.splice(targetList.indexOf(task), 1)
    })
    );

    tasks.forEach(task => {
      let targetTask = targetList.find(item => item.gid == task.gid);
      if (targetTask) {
        targetTask.update(task);
      } else {
        !task.taskName && task.analysisTaskName();
        targetList.push(task)
      }
    })


  }

  aboutToAppear(): void {
    if (this.defaultAria2) {
      this.timer = setInterval(() => {
        let taskStatus = this.taskViewModel.taskStatus
        this.defaultAria2 && RpcService.tell(this.defaultAria2, taskStatus).then((tasks) => {
          this.updateTasks(tasks, taskStatus)
        })
      }, 1000)
    }
  }

  aboutToDisappear(): void {
    this.timer && clearInterval(this.timer)
  }

  @Builder
  buildContextMenu($$: GeneratedTypeLiteralInterface_2) {
    Menu() {
      MenuItem({ symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.trash')), content: "删除", }).onClick(() => {
        this.defaultAria2 && RpcService.removeTask(this.defaultAria2, $$.task.gid!);
      })
      MenuItem({ symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.link')), content: "复制链接" }).onClick(() => {
        PasteboardUtil.setDataText($$.task.getUri())
      })
      MenuItem({ symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.info_circle')), content: "详情" })
    }
  }

  @Builder
  buildTasksContent($$: GeneratedTypeLiteralInterface_1) {
    RelativeContainer() {
      if ($$.tasks.length == 0) {
        Image($r('app.media.empty')).size({ width: 500, height: 500 }).alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
        }).opacity(0.5).transition(MyTransitionEffects.OPACITY)
      }
      List({ space: 10 }) {
        ForEach($$.tasks, (item: Task, index: number) => {
          this.buildListItem(item)
        })
      }.transition(MyTransitionEffects.OPACITY).chainAnimation(true).scrollBar(BarState.Off)
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
          symbolIcon: new SymbolGlyphModifier($r('sys.symbol.plus')),
          value: "新增",
          action: () => {
            this.taskAddSheetRef.value?.open();
          }
        },
        {
          symbolIcon: new SymbolGlyphModifier($r('sys.symbol.download')),
          value: "下载中",
          action: () => {
            this.taskViewModel.swiperController.changeIndex(0, true)
          }
        },
        {
          symbolIcon: new SymbolGlyphModifier($r('sys.symbol.timer')),
          value: "等待中",
          action: () => {
            this.taskViewModel.swiperController.changeIndex(1, true)
          }
        },
        {
          symbolIcon: new SymbolGlyphModifier($r('sys.symbol.pause')),
          value: "已暂停",
          action: () => {
            this.taskViewModel.swiperController.changeIndex(2, true)
          }
        },
        {
          symbolIcon: new SymbolGlyphModifier($r('sys.symbol.flag_checkered')),
          value: "已完成",
          action: () => {
            this.taskViewModel.swiperController.changeIndex(3, true)
          }
        },
        {
          symbolIcon: new SymbolGlyphModifier($r('sys.symbol.trash')),
          value: "已删除",
          action: () => {
            this.taskViewModel.swiperController.changeIndex(4, true)
          }
        },
        {
          symbolIcon: new SymbolGlyphModifier($r('sys.symbol.warning')),
          value: "错误",
          action: () => {
            this.taskViewModel.swiperController.changeIndex(5, true)
          }
        }
      ])
    }.margin(20)
  }

  build() {

    Navigation() {
      TaskEditSheet({
        ref: this.taskAddSheetRef
      })
      Swiper(this.taskViewModel.swiperController) {
        this.buildTasksContent({ tasks: this.activeTasks })
        this.buildTasksContent({ tasks: this.waitingTasks })
        this.buildTasksContent({ tasks: this.pausedTasks })
        this.buildTasksContent({ tasks: this.completeTasks })
        this.buildTasksContent({ tasks: this.removedTasks })
        this.buildTasksContent({ tasks: this.errorTasks })
      }.loop(false).indicator(false).onChange((index) => {
        this.toggleTaskStatus(index)
      }).height('100%')

    }.title(this.taskViewModel.title)
    // .menus([
    //   {
    //     value: TaskStatus.paused.toString(),
    //     symbolIcon: new SymbolGlyphModifier($r('sys.symbol.pause')),
    //     action: () => {
    //       this.taskViewModel.swiperController.changeIndex(2, true)
    //     }
    //   },
    //   {
    //     value: TaskStatus.waiting.toString(),
    //     symbolIcon: new SymbolGlyphModifier($r('sys.symbol.stopwatch')),
    //     action: () => {
    //       this.taskViewModel.swiperController.changeIndex(1, true)
    //     }
    //   },
    //   {
    //     value: TaskStatus.active.toString(),
    //     symbolIcon: new SymbolGlyphModifier($r('sys.symbol.play')),
    //     action: () => {
    //       this.taskViewModel.swiperController.changeIndex(0, true)
    //     }
    //   },
    // ])
    .menus(this.buildMenus())
    .backButtonIcon($r('sys.media.ohos_ic_public_arrow_left')).titleMode(NavigationTitleMode.Mini)

  }

  toggleTaskStatus(index: number | TaskStatus) {
    this.taskViewModel.toggleStatus(index);
  }

  @Builder
  buildListItem(item: Task) {
    if (item.status == TaskStatus.error || item.status == TaskStatus.removed) {
      ListItem() {
        TaskCard({
          task: item
        }).width('100%').height(150)
      }.transition({ type: TransitionType.All, opacity: 0 })
    } else {
      ListItem() {
        TaskCard({
          task: item
        }).width('100%').height(150)
      }.bindContextMenu(this.buildContextMenu({ task: item }), ResponseType.LongPress, {
        preview: MenuPreviewMode.IMAGE,
      })
    }


  }

  test(changedPropertyName: string) {
    console.log("aaaaa");
  }
}