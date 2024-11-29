import GlobalStatus from '../model/GlobalStatus';

@Observed
export class ServerViewModel {
  private maxDownLoadSpeed: number = 0;
  private maxUploadSpeed: number = 0;
  @Track
  totalNum: number = 0;
  @Track
  state: ServerState = ServerState.disconnected;
  @Track
  currentDownloadSpeed: number = 0;
  @Track
  currentUploadSpeed: number = 0;
  @Track
  downloadPercent: number = 0;
  @Track
  uploadPercent: number = 0;
  @Track
  numActive: number = 0;
  @Track
  numWaiting: number = 0;
  @Track
  numStopped: number = 0;
  @Track
  rotateAngle: number = 360
  @Track
  selectedIconColor: ResourceColor = Color.Gray;

  updateGlobalStatus(globalStatus: GlobalStatus) {
    this.currentDownloadSpeed = globalStatus.downloadSpeed;
    this.currentUploadSpeed = globalStatus.uploadSpeed;
    this.maxDownLoadSpeed = Math.max(this.maxDownLoadSpeed, this.currentDownloadSpeed);
    this.maxUploadSpeed = Math.max(this.maxUploadSpeed, this.currentUploadSpeed);
    this.numActive = globalStatus.numActive;
    this.numWaiting = globalStatus.numWaiting;
    this.numStopped = globalStatus.numStopped;
    this.downloadPercent = this.currentDownloadSpeed / this.maxDownLoadSpeed;
    this.uploadPercent = this.currentUploadSpeed / this.maxUploadSpeed
    this.totalNum = this.numActive + this.numWaiting + this.numStopped
  }
}


export enum ServerState { connecting, connected, disconnected, monitoring, error }
