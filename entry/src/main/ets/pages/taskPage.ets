import Aria2 from '../model/Aria2';
import { Task, TaskStatus } from '../model/Task';
import { Aria2Keys } from '../static/PersistentKeys';
import TaskViewModel from '../viewModel/TaskViewModel';
import { SymbolGlyphModifier } from '@kit.ArkUI';
import RpcService from '../service/RpcService';
import { TaskCard } from '../view/TaskCard';
import { PasteboardUtil } from '@pura/harmony-utils';

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
    targetList.splice(targetList.indexOf(task), 1));

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
        console.log(this.taskViewModel.taskStatus.toString())
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
  buildContextMenu(task: Task, index: number) {
    Menu() {
      MenuItem({ symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.trash')), content: "删除", }).onClick(() => {
        this.defaultAria2 && RpcService.removeTask(this.defaultAria2, task.gid!);
      })
      MenuItem({ symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.link')), content: "复制链接" }).onClick(() => {
        PasteboardUtil.setDataText(task.getUri())
      })
      MenuItem({ symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.info_circle')), content: "详情" })
    }
  }

  @Builder
  buildTasksContent(tasks: Array<Task>) {
    RelativeContainer() {
      if (tasks.length == 0) {
        Image($r('app.media.empty')).size({ width: 500, height: 500 }).alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
        })
      }
      List({ space: 20 }) {
        ForEach(tasks, (item: Task, index: number) => {
          this.buildListItem(item, index)
        })
      }
    }
  }

  build() {

    Navigation() {
      Swiper(this.taskViewModel.swiperController) {
        this.buildTasksContent(this.activeTasks)
        this.buildTasksContent(this.waitingTasks)
        this.buildTasksContent(this.pausedTasks)
        this.buildTasksContent(this.completeTasks)
        this.buildTasksContent(this.removedTasks)
        this.buildTasksContent(this.errorTasks)
      }.loop(false).indicator(false).onChange((index) => {
        this.toggleTaskStatus(index)
      }).height('100%')

    }.title(this.taskViewModel.title)
    .menus([
      {
        value: TaskStatus.paused.toString(),
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.pause')),
        action: () => {
          this.taskViewModel.swiperController.changeIndex(2, true)
        }
      },
      {
        value: TaskStatus.waiting.toString(),
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.stopwatch')),
        action: () => {
          this.taskViewModel.swiperController.changeIndex(1, true)
        }
      },
      {
        value: TaskStatus.active.toString(),
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.play')),
        action: () => {
          this.taskViewModel.swiperController.changeIndex(0, true)
        }
      },
    ])
    .backButtonIcon($r('app.media.Aria2')).titleMode(NavigationTitleMode.Mini)

  }

  toggleTaskStatus(index: number | TaskStatus) {
    this.taskViewModel.toggleStatus(index);
  }

  @Builder
  buildListItem(item: Task, index: number) {
    ListItem() {
      TaskCard({
        task: item
      }).width('100%').height(150)
    }.bindContextMenu(this.buildContextMenu(item, index), ResponseType.LongPress, {
      preview: MenuPreviewMode.IMAGE,
    })
  }

  test(changedPropertyName: string) {
    console.log("aaaaa");
  }
}