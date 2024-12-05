import Aria2 from '../model/Aria2';
import { Task, TaskFile, TaskStatus } from '../model/Task';
import { Aria2Keys } from '../static/PersistentKeys';
import router from '@ohos.router';
import RpcService from '../service/RpcService';
import LoadingWidget from '../view/LoadingWidget';
import Form, { FormItemOptionInterface, FormItemType } from '../view/form/Form';
import ComponentRef from '../view/ComponentRef';
import CommonUtils from '../utils/CommonUtils';
import PieceInfoWidget, { PieceInfoType, Piece } from '../view/PieceInfoWidget';


@Entry
@Component
struct TaskDetailPage {
  @StorageProp(Aria2Keys.DEFAULT) defaultAria2: Aria2 | undefined = undefined;
  private task?: Task;
  private promise?: Promise<boolean>;
  formRef = ComponentRef.useRef<Form>();
  @State model: Map<string, string> = new Map();
  @State piece: Piece = new Piece(0, 'f');
  private formItems: FormItemOptionInterface[] = [];
  private isInit = true;

  aboutToAppear(): void {
    this.task = router.getParams() as Task;
    this.promise = new Promise<boolean>((resolve, reject) => {
      (this.task && this.defaultAria2) && RpcService.tellStatus(this.defaultAria2, this.task.gid!).then((task) => {
        task.taskName = this.task?.taskName;
        this.task = task;
        this.piece.numPieces = this.task.numPieces ?? 0;
        this.piece.bitfield = this.task.bitfield ?? "f";
        this.updateForm(this.task);
        this.isInit = false;
        resolve(true);
      }).catch(() => {
        reject()
      });
    });


  }

  aboutToDisappear(): void {
    this.isInit = true;
  }

  updateForm(task: Task) {
    let totalLength = CommonUtils.formatBytes(task.totalLength);
    this.updateFormItem("task-name", task.taskName ?? "");
    this.updateFormItem("task-size", totalLength);
    this.updateFormItem("task-status", CommonUtils.convertTaskStatusToString(task.status));
    this.updateFormItem("task-process", task.computedPercentageString());
    if (task.status == TaskStatus.active) {
      let downloadSpeed = CommonUtils.formatBytes(task.downloadSpeed);
      this.updateFormItem("download-speed", downloadSpeed);
    }
    if (task.isBitTorrent()) {
      let uploadSpeed = CommonUtils.formatBytes(task.uploadSpeed);
      this.updateFormItem("upload-speed", uploadSpeed);
      this.updateFormItem("share-ratio", task.getShareRatio());
      this.updateFormItem("seeders-connections", task.getSeedersConnections().toString());
      this.updateFormItem("creation-date", task.getCreationDate());
      this.updateFormItem("info-hash", task.infoHash ?? "");
    }
    if (task.status == TaskStatus.active) {
      this.updateFormItem("remain-time", task.getRemainTime());
    }
    if (!task.isBitTorrent()) {
      this.updateFormItem("connections", task.connections?.toString() ?? "");
      this.updateFormItem("download-url", task.getUri() ?? "");

    }
    this.updateFormItem("download-path", task.getDownloadPath() ?? "");
  }

  updateFormItem(key: string, value: string) {
    this.model.set(key, value ?? "");
    if (this.isInit) {
      this.formItems.push({
        type: FormItemType.input,
        readOnly: true,
        key: key,
      })
    }

  }

  @LocalBuilder
  buildFinish() {
    Tabs({ barPosition: BarPosition.Start }) {
      TabContent() {
        this.buildOverview()
      }
      .tabBar($r('app.string.task_detail_page_overview'))

      TabContent() {
        this.buildPieceInfo()
      }
      .tabBar($r('app.string.task_detail_page_pieces'))

      TabContent() {
        this.buildFileList()
      }
      .tabBar($r('app.string.task_detail_page_files'))

      if (this.task?.isBitTorrent()) {
        TabContent() {
          Text('BT信息').fontSize(30)
        }
        .tabBar('BT信息')
      }
    }
  }

  @Builder
  buildFileList() {
    List({ space: 10 }) {
      ForEach(this.task?.files, (taskFile: TaskFile, index: number) => {
        ListItem() {
          Column() {
            Row() {
              Text(this.task?.getFileName(taskFile))
              Blank()
              Checkbox().select(taskFile.selected).onClick(() => {
                taskFile.selected = !taskFile.selected;
              })
            }.width('100%')

            Row() {
              Text(this.task?.computedFilePercentage(taskFile))
              Blank()
              Text(CommonUtils.formatBytes(taskFile.length))
            }.width('100%')
          }.shadow(1).justifyContent(FlexAlign.SpaceBetween)
          .height(70).padding(5)
        }

      })
    }.alignListItem(ListItemAlign.Start).height('100%').divider({
      strokeWidth: 1
    })
  }

  @Builder
  buildPieceInfo() {
    PieceInfoWidget({
      piece: this.piece,
      type: PieceInfoType.grid
    })
  }

  @Builder
  buildOverview() {
    Form({
      option: {
        dividerMargin: { left: 10 },
        textAlign: TextAlign.End
      },
      formRef: this.formRef,
      footer: undefined,
      groups: [
        {
          option: {},
          children: this.formItems
        }
      ],
      model: this.model,
      onChange: (key, value) => {

      }
    }).height('100%')
  }

  build() {
    Stack() {
      LoadingWidget({
        failedMessage: "加载失败，请检查网络或服务器",
        promise: this.promise,
        finishBuilder: this.buildFinish,
      })
    }.width('100%').height('100%')
  }
}