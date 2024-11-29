import { Task, TaskStatus } from "../model/Task";

@Observed
export default class TaskViewModel {
  @Track
  title: string = "下载中";
  @Track
  taskStatus: TaskStatus = TaskStatus.active;
  @Track toggle: boolean = false;
  @Track activeTasks: Array<Task> = [];
  @Track waitingTasks: Array<Task> = [];
  @Track pausedTasks: Array<Task> = [];
  @Track completeTasks: Array<Task> = [];
  @Track removedTasks: Array<Task> = [];
  @Track errorTasks: Array<Task> = [];
  @Track swiperController: SwiperController = new SwiperController();

  toggleStatus(status: TaskStatus) {
    if (this.taskStatus == status) {
      return;
    }
    this.taskStatus = status;
    switch (this.taskStatus) {
      case TaskStatus.active:
        this.title = "下载中";
        break;
      case TaskStatus.paused:
        this.title = "已暂停";
        break;
      case TaskStatus.waiting:
        this.title = "等待中";
        break;
      case TaskStatus.complete:
        this.title = "已完成";
        break;
      case TaskStatus.removed:
        this.title = "已删除";
        break;
      case TaskStatus.error:
        this.title = "错误";
        break;
    }
    this.toggle = !this.toggle;
  }
}