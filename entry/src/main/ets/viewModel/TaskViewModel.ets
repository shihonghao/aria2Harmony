import { TaskStatus } from '../model/Task';

@Observed
export default class TaskViewModel {
  @Track
  title: string | Resource = $r('app.string.download_label');
  @Track
  taskStatus: TaskStatus = TaskStatus.active;
  @Track toggle: boolean = false;
  @Track swiperController: SwiperController = new SwiperController();

  toggleStatus(status: TaskStatus) {
    if (this.taskStatus == status) {
      return;
    }
    this.taskStatus = status;
    switch (this.taskStatus) {
      case TaskStatus.active:
        this.title = $r('app.string.download_label');
        break;
      case TaskStatus.paused:
        this.title = $r('app.string.paused_label');
        break;
      case TaskStatus.waiting:
        this.title = $r('app.string.waiting_label');
        break;
      case TaskStatus.complete:
        this.title = $r('app.string.completed_label');
        break;
      case TaskStatus.removed:
        this.title = $r('app.string.removed_label');
        break;
      case TaskStatus.error:
        this.title = $r('app.string.error_label');
        break;
    }
    this.toggle = !this.toggle;
  }
}