import Form from '../form/Form';
import { promptAction } from '@kit.ArkUI';
import LoadingWidget from '../LoadingWidget';
import ComponentRef from '../ComponentRef';
import { DisplayUtil, JSONUtil } from '@pura/harmony-utils';
import { Expose, Transform } from 'class-transformer';
import GlobalOptions, { convertToBool, convertToNumber } from '../../model/GlobalOptions';
import Aria2Service from '../../service/Aria2Service';
import RpcService from '../../service/RpcService';
import Aria2 from '../../model/Aria2';
import { Aria2Keys } from '../../static/PersistentKeys';

class DownloadOptions {
  static fromGlobalOption(globalOption: GlobalOptions): DownloadOptions {
    let downloadOptions = new DownloadOptions();
    downloadOptions.dir = globalOption.dir;
    downloadOptions.allowOverwrite = globalOption.allowOverwrite;
    downloadOptions.maxDownloadLimit = globalOption.maxDownloadLimit;
    downloadOptions.maxUploadLimit = globalOption.maxUploadLimit;
    downloadOptions.split = globalOption.split;
    downloadOptions.minSplitSize = globalOption.minSplitSize;
    downloadOptions.maxConnectionPerServer = globalOption.maxConnectionPerServer;
    downloadOptions.lowestSpeedLimit = globalOption.lowestSpeedLimit;
    downloadOptions.streamPieceSelector = globalOption.streamPieceSelector;
    downloadOptions.httpUser = globalOption.httpUser;
    downloadOptions.httpPasswd = globalOption.httpPasswd;
    downloadOptions.allProxy = globalOption.allProxy;
    downloadOptions.referer = globalOption.referer;
    downloadOptions.header = globalOption.header;
    downloadOptions.btMaxPeers = globalOption.btMaxPeers;
    downloadOptions.btRequestPeerSpeedLimit = globalOption.btRequestPeerSpeedLimit;
    downloadOptions.btRemoveUnselectedFile = globalOption.btRemoveUnselectedFile;
    downloadOptions.btStopTimeOut = globalOption.btStopTimeOut;
    downloadOptions.btTracker = globalOption.btTracker;
    downloadOptions.seedRatio = globalOption.seedRatio;
    downloadOptions.seedTime = globalOption.seedTime;
    downloadOptions.conditionalGet = globalOption.conditionalGet;
    downloadOptions.fileAllocation = globalOption.fileAllocation;
    downloadOptions.parameterizedUri = globalOption.parameterizedUri;
    downloadOptions.forceSave = globalOption.forceSave;
    return downloadOptions;
  }

  dir?: string;
  out?: string;
  @Expose({
    name: 'allow-overwrite'
  }) @Transform(convertToBool) allowOverwrite?: boolean;
  @Expose({
    name: 'max-download-limit'
  }) @Transform(convertToNumber) maxDownloadLimit?: number;
  @Expose({
    name: 'max-upload-limit'
  }) @Transform(convertToNumber) maxUploadLimit?: number;
  @Expose({
    name: 'split'
  }) @Transform(convertToNumber) split?: number;
  @Expose({
    name: 'min-split-size'
  }) @Transform(convertToNumber) minSplitSize?: number;
  @Expose({
    name: 'max-connection-per-server'
  }) @Transform(convertToNumber) maxConnectionPerServer?: number;
  @Expose({
    name: 'lowest-speed-limit'
  }) @Transform(convertToNumber) lowestSpeedLimit?: number;
  @Expose({
    name: 'stream-piece-selector'
  }) streamPieceSelector?: string;
  @Expose({
    name: 'http-user'
  }) httpUser?: string;
  @Expose({
    name: 'http-passwd'
  }) httpPasswd?: string;
  allProxy?: string;
  @Expose({
    name: 'referer'
  }) referer?: string;
  @Expose({
    name: 'header'
  }) header?: string;
  @Expose({
    name: 'bt-max-peers'
  }) @Transform(convertToNumber) btMaxPeers?: number;
  @Expose({
    name: 'bt-request-peer-speed-limit'
  }) @Transform(convertToNumber) btRequestPeerSpeedLimit?: number;
  @Expose({
    name: 'bt-remove-unselected-file'
  }) @Transform(convertToBool) btRemoveUnselectedFile?: boolean;
  @Expose({
    name: 'bt-stop-time-out'
  }) @Transform(convertToNumber) btStopTimeOut?: number;
  @Expose({
    name: 'bt-tracker'
  }) btTracker?: string;
  @Expose({
    name: 'seed-ratio'
  }) @Transform(convertToNumber) seedRatio?: number;
  @Expose({
    name: 'seed-time',
  }) @Transform(convertToNumber) seedTime?: number;
  @Expose({
    name: 'conditional-get'
  }) @Transform(convertToBool) conditionalGet?: boolean;
  @Expose({
    name: 'file-allocation'
  }) fileAllocation?: string;
  @Expose({
    name: 'parameterized-uri'
  }) @Transform(convertToBool) parameterizedUri?: boolean;
  @Expose({
    name: 'force-save'
  }) @Transform(convertToBool) forceSave?: boolean;
}

@Component
export default struct TaskEditSheet {
  @StorageProp(Aria2Keys.DEFAULT) defaultAria2: Aria2 | undefined = undefined;
  ref?: ComponentRef<TaskEditSheet>
  @State showSheet: boolean = false;
  @State urlString: string = "";
  @State sheetSize: SheetSize = SheetSize.MEDIUM
  dialogId?: number;
  formRef: ComponentRef<Form> = ComponentRef.useRef<Form>()
  @State model: Map<string, string> = new Map()
  globalOptionMap: Map<string, string> = new Map();
  pageStack: NavPathStack = new NavPathStack()


  aboutToDisappear(): void {

  }

  @Builder
  nothingToBuild() {
  }

  @BuilderParam childBuilder: () => void = this.nothingToBuild;

  aboutToAppear(): void {
    this.ref?.bind(this)

  }

  initModel() {
    this.defaultAria2 && RpcService.getGlobalOptions(this.defaultAria2).then((globalOption) => {
      let downLoadOption = DownloadOptions.fromGlobalOption(globalOption);
      JSONUtil.jsonToMap(JSONUtil.beanToJsonStr(downLoadOption)).forEach((value, key, map) => {
        this.globalOptionMap.set(key,
          (value == null || value == undefined || value == 'undefined') ? "" : value.toString());
        this.model.set(key, (value == null || value == undefined || value == 'undefined') ? "" : value.toString());
      })
    })

  }

  build() {
    Column().bindSheet(this.showSheet, this.buildContent()
      , {
        onAppear: () => {
          this.initModel();
        },
        onDisappear: () => {
          this.model.clear();
        },
        height: SheetSize.FIT_CONTENT,
        blurStyle: BlurStyle.Thin,
        showClose: false,
        // backgroundColor: '#ffd9d9d9',
        onWillDismiss: (action) => {
          this.getUIContext().showAlertDialog({
            title: $r('app.string.warning'),
            message: $r('app.string.task_add_sheet_warning_message'),
            isModal: true,
            primaryButton: {
              enabled: true,
              value: $r('app.string.confirm'),
              action: () => {
                this.close();
              }
            },
            secondaryButton: {
              enabled: true,
              value: $r('app.string.cancel'),
              action: () => {

              }
            }
          });
        }
      })
  }

  @Builder
  buildLoadingWidget(urls: Array<string>) {
    LoadingWidget({
      successMessage: "添加成功",
      failedMessage: "添加失败",
      onFinish: () => {
        if (this.dialogId) {
          setTimeout(() => {
            promptAction.closeCustomDialog(this.dialogId);
            this.close();
          }, 500)
        }
      },
      onError: () => {
        if (this.dialogId) {
          setTimeout(() => {
            promptAction.closeCustomDialog(this.dialogId);
          }, 500)
        }
      },
      promise: new Promise<boolean>((resolve, reject) => {
        setTimeout(() => {
          let requestParamMap: Map<string, string> = new Map();
          for (let entry of this.model.entries()) {
            if (this.globalOptionMap.get(entry[0]) != entry[1]) {
              requestParamMap.set(entry[0], entry[1])
            }
          }

          if (this.defaultAria2) {
            RpcService.createTask(this.defaultAria2, urls, requestParamMap).then(() => {
              resolve(true)
            }).catch(() => {
              reject()
            })
          } else {
            reject();
          }
        }, 500)
      })
    })
  }

  @Builder
  buildContent() {
    Navigation(this.pageStack) {
      Column() {
        TextArea({
          text: this.urlString,
          placeholder: $r('app.string.task_add_sheet_download_url_placeholder')
        }).borderRadius(10).height('50%').onChange((value) => {
          this.urlString = value;
        })
        Row() {
          Button($r('app.string.task_add_sheet_advance'))
            .type(ButtonType.Capsule)
            .backgroundColor(Color.Transparent)
            .fontColor($r('app.color.active_color'))
            .margin(10)
            .onClick(() => {
              this.pageStack.pushPath({ name: "pageOne" })
            })
        }.width('100%').justifyContent(FlexAlign.End)

        Button($r('app.string.task_add_sheet_download'), {
          type: ButtonType.Normal
        }).borderRadius(5).width('80%').onClick(() => {
          let urls = this.urlString.split("\n");
          //todo 校验url合法性
          if (urls.length != 0) {
            promptAction.openCustomDialog({
              builder: () => {
                this.buildLoadingWidget(urls)
              },
              width: 200,
              height: 200,
              backgroundBlurStyle: BlurStyle.BACKGROUND_THIN,
              autoCancel: false
            }).then((id) => {
              this.dialogId = id;
            })
          }

        }).margin(5)
      }.margin(10)

    }.expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
    .title($r('app.string.add'))
    .titleMode(NavigationTitleMode.Mini)
    .navDestination(this.buildChild)
  }

  @Builder
  buildChild(name: string) {
    NavDestination() {
      Column() {
        Form({
          option: {
            dividerMargin: { left: 10 },
            textAlign: TextAlign.End
          },
          formRef: this.formRef,
          footer: undefined,
          groups: Aria2Service.instance.taskOptionFormGroups,
          model: this.model,
          onChange: (key, value) => {
          }
        })
      }
    }
    // .title($r('app.string.task_add_sheet_download_options'))

  }

  open(): void {
    this.showSheet = true
  }

  close(): void {
    this.showSheet = false;
  }
}

