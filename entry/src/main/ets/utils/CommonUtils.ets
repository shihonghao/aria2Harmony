import { TaskStatus } from '../model/Task';
import { resourceManager } from '@kit.LocalizationKit';

const sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

export default class CommonUtils {
  static i18n(key: string): string {
    return "app.string." + key;
  }

  static formatBytes(bytes: number = 0, decimals: number = 2) {
    if (bytes === 0) {
      return '0 B';
    }
    const k = 1024;
    const dm = decimals < 0 ? 0 : decimals;
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
  }

  static convertTaskStatusToString(status?: TaskStatus): string {
    switch (status) {
      case TaskStatus.active:
        return "active";
      case TaskStatus.removed:
        return "removed";
      case TaskStatus.paused:
        return "paused";
      case TaskStatus.waiting:
        return "waiting";
      case TaskStatus.complete:
        return "complete";
      case TaskStatus.error:
        return "error";
      default:
        return "active";
    }
  }

  static convertStringToTaskStatus(statusString?: string): TaskStatus {
    switch (statusString) {
      case "active":
        return TaskStatus.active;
      case "paused":
        return TaskStatus.paused;
      case "waiting":
        return TaskStatus.waiting;
      case "complete":
        return TaskStatus.complete;
      case "error":
        return TaskStatus.error;
      case "removed":
        return TaskStatus.removed;
      default:
        return TaskStatus.active;
    }
  }
}