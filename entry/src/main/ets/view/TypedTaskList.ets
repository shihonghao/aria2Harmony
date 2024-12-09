import MyTransitionEffects from '../effects/MyTransitionEffects';
import Aria2 from '../model/Aria2';
import { Task, TaskStatus } from '../model/Task';
import { Aria2Keys } from '../static/PersistentKeys';
import { TaskCard } from './TaskCard';
import { router, SymbolGlyphModifier } from '@kit.ArkUI';
import RpcService from '../service/RpcService';
import { PasteboardUtil } from '@pura/harmony-utils';
import ComponentRef from './ComponentRef';


@Component
export default struct TypedTaskList {
  @Prop taskStatus: TaskStatus;
  @State tasks: Task[] = [];
  @StorageProp(Aria2Keys.DEFAULT) defaultAria2: Aria2 | undefined = undefined;
  private scroller: ListScroller = new ListScroller()
  ref?: ComponentRef<TypedTaskList>;

  aboutToAppear(): void {
    this.ref?.bind(this);
  }

  fetchData() {
    this.defaultAria2 &&
    RpcService.tell(this.defaultAria2, this.taskStatus).then((tasks) => {
      this.updateTasks(tasks)
    })
  }

  private updateTasks(tasks: Array<Task>) {
    let removeArray = this.tasks.filter(o1 => tasks.findIndex(o2 => o1.gid == o2.gid) == -1)
    removeArray.forEach(task =>
    animateTo({ duration: 200 }, () => {
      this.tasks.splice(this.tasks.indexOf(task), 1)
    })
    );

    tasks.forEach(task => {
      let targetTask = this.tasks.find(item => item.gid == task.gid);
      if (targetTask) {
        targetTask.update(task);
      } else {
        !task.taskName && task.analysisTaskName();
        animateTo({ duration: 200 }, () => {
          this.tasks.push(task)
        })
      }
    })


  }

  build() {
    Column() {
      if (this.tasks.length == 0) {
        Image($r('app.media.empty')).size({ width: 500, height: 500 }).opacity(0.5)
          .transition(MyTransitionEffects.OPACITY)
      }
      List({ space: 10, scroller: this.scroller }) {
        ForEach(this.tasks, (item: Task) => {
          ListItem() {
            TaskCard(
              { task: item }
            )
          }.height(150)
          .transition(TransitionEffect.opacity(0)
            .combine(TransitionEffect.asymmetric(TransitionEffect.move(TransitionEdge.BOTTOM),
              TransitionEffect.move(TransitionEdge.END))))
          .bindContextMenu(this.buildContextMenu({ task: item }), ResponseType.LongPress, {
            preview: MenuPreviewMode.IMAGE,
            placement:Placement.BottomRight
          })
        }, (item: Task) => item.gid)
      }.height('100%')
    }
    .padding(10)
    .width('100%')
    .height('100%').justifyContent(FlexAlign.Center)
  }

  @Builder
  buildContextMenu($$: GeneratedTypeLiteralInterface_2) {
    Menu() {

      MenuItem({ symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.link')), content:  $r('app.string.task_page_action_copyLink') }).onClick(() => {
        PasteboardUtil.setDataText($$.task.getUri())
      })
      // MenuItem({ symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.info_circle')), content:  $r('app.string.info') })
      //   .onClick(() => {
      //     router.pushUrl({ url: "pages/taskDetailPage", params: $$.task })
      //   })
      if($$.task.status == TaskStatus.active){
        MenuItem({ symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.pause')), content:  $r('app.string.pause_task') }).onClick(() => {
          this.defaultAria2 && RpcService.pauseTask(this.defaultAria2, $$.task.gid!)
        })
      }
      if($$.task.status == TaskStatus.paused){
        MenuItem({ symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.play')), content:  $r('app.string.unPause_task') }).onClick(() => {
          this.defaultAria2 && RpcService.unpauseTask(this.defaultAria2, $$.task.gid!)
        })
      }
      MenuItem({ symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.trash')), content: $r('app.string.delete') }).onClick(() => {
        if ($$.task.status == TaskStatus.complete || $$.task.status == TaskStatus.removed ||
          $$.task.status == TaskStatus.error) {
          this.defaultAria2 && RpcService.removeDownloadResult(this.defaultAria2, $$.task.gid!);
        } else {
          this.defaultAria2 && RpcService.removeTask(this.defaultAria2, $$.task.gid!, true);
        }
      })
    }
  }
}


interface GeneratedTypeLiteralInterface_2 {
  task: Task;
}