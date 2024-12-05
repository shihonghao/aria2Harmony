import { DateUtil } from '@pura/harmony-utils'
import { Transform, TransformFnParams, Type } from 'class-transformer'
import CommonUtils from '../utils/CommonUtils'
import { convertToBool, convertToNumber } from './GlobalOptions'

export enum TaskStatus {
  active,
  waiting,
  paused,
  complete,
  removed,
  error,
}

@Observed
export class Task {
  // 下载的 GID
  gid?: string
  taskName?: string
  // 下载状态
  //  active   当前正在下载/做种的下载
  //  waiting  在队列中的下载；下载尚未开始
  //  paused   暂停的下载
  //  error    因错误而停止的下载
  //  complete 停止并完成的下载
  //  removed  用户移除的下载
  @Transform((param: TransformFnParams) => {
    if (typeof param.value == 'string') {
      return CommonUtils.convertStringToTaskStatus(param.value);
    } else {
      return (param.value as TaskStatus).toString();
    }
  })
  status?: TaskStatus
  // 下载的总长度（以字节为单位）
  @Transform(convertToNumber)
  totalLength?: number
  // 下载的已完成长度（以字节为单位）
  @Transform(convertToNumber)
  completedLength?: number
  @Transform(convertToNumber)
  lastCompletedLength?: number
  // 上传的长度（以字节为单位）
  @Transform(convertToNumber)
  uploadLength?: number
  // 下载进度的十六进制表示。最高位对应索引为 0 的片段。任何被设定的位表示已加载的片段，而未设置的位表示尚未加载和/或丢失的片段。末尾的任何溢出位被设定为零。当下载尚未开始时，此键不会包含在响应中。
  bitfield?: string
  // 下载速度（以字节/秒为单位）
  @Transform(convertToNumber)
  downloadSpeed?: number
  // 上传速度（以字节/秒为单位）
  @Transform(convertToNumber)
  uploadSpeed?: number
  // InfoHash。仅适用于 BitTorrent。
  infoHash?: string
  // aria2 连接的做种者数量。仅适用于 BitTorrent。
  @Transform(convertToNumber)
  numSeeders?: number
  // 是否是做种者,仅适用于 BitTorrent。
  @Transform(convertToBool)
  seeder?: boolean
  // 片段长度（以字节为单位）
  @Transform(convertToNumber)
  pieceLength?: number
  // 片段数量
  @Transform(convertToNumber)
  numPieces?: number
  // aria2 连接到的对等方/服务器数量
  @Transform(convertToNumber)
  connections?: number
  //对于此项的最后一个错误代码，如果有的话。值为字符串。错误代码在 退出状态 部分中有定义。此值仅适用于已停止/已完成的下载。
  @Transform(convertToNumber)
  errorCode?: number
  // 错误消息
  errorMessage?: string
  // 生成为此下载结果的 GID 列表。
  // 例如，当 aria2 下载一个 Metalink 文件时，会生成 Metalink 中描述的下载（参见 --follow-metalink 选项）。此值对于跟踪自动生成的下载非常有用。如果没有这样的下载，则此键不会包含在响应中
  followedBy?: Array<string>
  // “followedBy”的反向链接。包含在“followedBy”中的下载在其 following 值中具有该对象的 GID。
  following?: string
  // 父下载的 GID。某些下载是另一个下载的一部分。例如，如果 Metalink 中的文件具有 BitTorrent 资源，则“.torrent”文件的下载是该父项的一部分。如果此下载没有父项，则此键不会包含在响应中。
  belongsTo?: string
  // 下载的目录
  dir?: string
  // 下载的文件列表
  @Type(() => TaskFile)
  files?: Array<TaskFile>
  @Type(() => Bittorrent)
  bittorrent?: Bittorrent
  // 在文件进行哈希检查时验证的字节数量。此键仅在此下载正在进行哈希检查时存在。
  verifiedLength?: string
  // 如果此下载正在等待在队列中进行哈希检查，则为“true”。此键仅在此下载在队列中时存在
  verifyIntegrityPending?: string
  @Transform(convertToNumber)
  lastDownloadSpeed?: number
  @Transform(convertToNumber)
  lastUploadSpeed?: number

  // constructor(gid: string, taskName: string, status: TaskStatus, totalLength: number,
  //   completedLength: number, lastCompletedLength: number, uploadLength: number,
  //   bitfield: string, downloadSpeed: number, uploadSpeed: number, infoHash: string,
  //   numSeeders: number, seeder: boolean, pieceLength: number, numPieces: number,
  //   connections: number, errorCode: number, errorMessage: string, followedBy: Array<string>,
  //   following: string, belongsTo: string, dir: string, files: Array<TaskFile>, bittorrent: Bittorrent,
  //   verifiedLength: string, verifyIntegrityPending: string, lastDownloadSpeed: number,
  //   lastUploadSpeed: number) {
  //   this.gid = gid
  //   this.taskName = taskName
  //   this.status = status
  //   this.totalLength = totalLength
  //   this.completedLength = completedLength
  //   this.lastCompletedLength = lastCompletedLength
  //   this.uploadLength = uploadLength
  //   this.bitfield = bitfield
  //   this.downloadSpeed = downloadSpeed
  //   this.uploadSpeed = uploadSpeed
  //   this.infoHash = infoHash
  //   this.numSeeders = numSeeders
  //   this.seeder = seeder
  //   this.pieceLength = pieceLength
  //   this.numPieces = numPieces
  //   this.connections = connections
  //   this.errorCode = errorCode
  //   this.errorMessage = errorMessage
  //   this.followedBy = followedBy
  //   this.following = following
  //   this.belongsTo = belongsTo
  //   this.dir = dir
  //   this.files = files
  //   this.bittorrent = bittorrent
  //   this.verifiedLength = verifiedLength
  //   this.verifyIntegrityPending = verifyIntegrityPending
  //   this.lastDownloadSpeed = lastDownloadSpeed
  //   this.lastUploadSpeed = lastUploadSpeed
  // }


  isBitTorrent(): boolean {
    return this.bittorrent != null;
  }

  update(task: Task) {
    this.lastCompletedLength = this.completedLength;
    this.lastUploadSpeed = this.uploadSpeed;
    this.lastDownloadSpeed = this.downloadSpeed;
    this.completedLength = task.completedLength;
    this.uploadLength = task.uploadLength;
    this.downloadSpeed = task.downloadSpeed;
    this.uploadSpeed = task.uploadSpeed;
    this.numPieces = task.numPieces;
    this.bitfield = task.bitfield;
  }

  getSeedersConnections(): number {
    if (this.isBitTorrent()) {
      return (this.numSeeders ?? 0) / (this.connections ?? 1)
    } else {
      return 0;
    }
  }

  getCreationDate(): string {
    if (this.isBitTorrent()) {
      return DateUtil.getFormatDateStr(new Date(this.bittorrent?.creationDate ?? 0))
    } else {
      return "N/A";
    }
  }

  getRemainTime(): string {
    if (this.downloadSpeed == 0) {
      return "More than one day";
    }
    let remainTime = "00:00:00";
    if (this.totalLength == 0) {
      return remainTime;
    }
    if (this.status == TaskStatus.active) {
      let seconds = (this.totalLength ?? 0 / (this.downloadSpeed ?? 1)) + 1;
      if (seconds > 0) {
        let remainSeconds = seconds;
        let hour = remainSeconds / 3600;
        let minute = (remainSeconds - hour * 3600) / 60;
        let second = remainSeconds - hour * 3600 - minute * 60;
        remainTime = (0 <= remainSeconds && remainSeconds < 86400) ?
          (hour.toString().padStart(2, '0') + ":" + minute.toString().padStart(2, '0') + ":" +
          second.toString().padStart(2, '0')) : "More than one day";
      }
    }
    return remainTime;
  }

  analysisTaskName() {
    let taskName = this.bittorrent?.info?.name;

    if (!taskName && this.files && this.files.length > 0) {
      taskName = this.getFileName(this.files[0]);
    }
    this.taskName = taskName ??= 'Unknown';
  }

  getFileName(file: TaskFile): string | undefined {
    let path = file.path;
    let needUrlDecode = false;

    if (!path ||
      path.length == 0 && file.uris && file.uris.length > 0) {
      path = file.uris![0].uri;
      needUrlDecode = true;
    }

    if (path == null) {
      return "Unknown";
    }

    let index = path.lastIndexOf('/');
    if (index <= 0 || index == path.length) {
      return path;
    }

    let fileNameAndQueryString = path.substring(index + 1);
    let queryStringStartPos = fileNameAndQueryString.indexOf('?');
    let fileName = fileNameAndQueryString;

    if (queryStringStartPos > 0) {
      fileName = fileNameAndQueryString.substring(0, queryStringStartPos);
    }

    if (needUrlDecode) {
      try {
        fileName = decodeURI(fileName);
      } catch (ex) {
        fileName = "Unknown";
      }
    }

    return fileName;
  }

  computedFilePercentage(file: TaskFile): string {
    return file.completedLength == null ||
      file.length == null ||
      file.length == 0
      ? "0 %"
      :
      ((file.completedLength  / file.length ) * 100).toFixed(2) +
        " %";
  }

  computedPercentageString(decimals: number = 2) {
    let result = this.computedPercentage()
    if (result != undefined) {
      return result.toFixed(decimals) + " %";
    } else {
      return "N/A"
    }
  }

  computedPercentage(): number | undefined {
    if (this.totalLength == undefined) {
      return undefined
    }
    return !this.completedLength || !this.totalLength || this.totalLength == 0
      ? 0
      : ((this.completedLength / this.totalLength) * 100);
  }

  getUri(): string | undefined {
    if (this.files &&
      this.files.length > 0 &&
    this.files[0].uris &&
      this.files[0].uris.length > 0) {
      return this.files[0].uris[0].uri;
    }
    return undefined;
  }

  getDownloadPath(): string | undefined {
    if (this.files && this.files.length > 0) {
      return this.files[0].path!.substring(0, this.files[0].path!.lastIndexOf("/"));
    }
    return undefined;
  }

  getShareRatio(): string {
    return (this.completedLength
      ? "0.0 %"
      : this.completedLength! > 0
        ? ((this.uploadLength ?? 0) / (this.completedLength ?? 1)).toFixed(2) + " %"
        : "0.0 %");
  }
}

export  class TaskFile {
  @Transform(convertToNumber)
  completedLength?: number;
  @Transform(convertToNumber)
  index?: number;
  @Transform(convertToNumber)
  length?: number;
  @Transform(convertToBool)
  selected?: boolean;
  @Type(() => TaskUri)
  uris?: Array<TaskUri>;
  path?: string;

  constructor(completedLength: number, index: number, length: number,
    selected: boolean, uris: Array<TaskUri>, path: string) {
    this.completedLength = completedLength
    this.index = index
    this.length = length
    this.selected = selected
    this.uris = uris
    this.path = path
  }
}

class TaskUri {
  uri?: string;
  status?: string;

  constructor(uri: string, status: string) {
    this.uri = uri
    this.status = status
  }
}

class Bittorrent {
  announceList?: Array<Array<string>>;
  comment?: string;
  @Transform(convertToNumber)
  creationDate?: number;
  mode?: string;
  info?: BittorrentInfo;

  constructor(announceList: Array<Array<string>>, comment: string, creationDate: number, mode: string,
    info: BittorrentInfo) {
    this.announceList = announceList
    this.comment = comment
    this.creationDate = creationDate
    this.mode = mode
    this.info = info
  }
}

class BittorrentInfo {
  name ?: string;

  constructor(name: string) {
    this.name = name
  }
}

class Peer {
  peerId?: string;
  ip?: string;
  port?: string;
  bitfield?: string;
  @Transform(convertToBool)
  amChoking?: boolean;
  @Transform(convertToBool)
  peerChoking?: boolean;
  @Transform(convertToNumber)
  downloadSpeed?: number;
  @Transform(convertToNumber)
  uploadSpeed?: number;
  @Transform(convertToBool)
  seeder?: boolean;
  client?: string;

  constructor(peerId: string, ip: string, port: string, bitfield: string, amChoking: boolean,
    peerChoking: boolean, downloadSpeed: number, uploadSpeed: number,
    seeder: boolean, client: string) {
    this.peerId = peerId
    this.ip = ip
    this.port = port
    this.bitfield = bitfield
    this.amChoking = amChoking
    this.peerChoking = peerChoking
    this.downloadSpeed = downloadSpeed
    this.uploadSpeed = uploadSpeed
    this.seeder = seeder
    this.client = client
  }
}