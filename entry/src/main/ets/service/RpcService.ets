import Aria2 from '../model/Aria2';
import { http } from '@kit.NetworkKit';
import { JSONUtil } from '@pura/harmony-utils';
import { Aria2Utils } from '../utils/Aria2Utils';
import Const from '../static/Const';
import Result from '../model/Result';
import { JSON } from '@kit.ArkTS';
import GlobalStatus from '../model/GlobalStatus';
import GlobalOptions from '../model/GlobalOptions';
import { Task, TaskStatus } from '../model/Task';

interface Aria2ParamInterface {
  key: string,
  value: string
}

type Aria2ParamType = Map<string, string> | Array<string> | string | number ;

class Aria2Response {
  id: string;
  jsonrpc: string;
  result?: string;
  code?: string;
  message?: string;

  constructor(id: string, jsonrpc: string, result?: string, code?: string, message?: string) {
    this.id = id;
    this.jsonrpc = jsonrpc;
    this.result = result;
    this.code = code;
    this.message = message;
  }
}

class Aria2Version {
  version: string;
  enabledFeatures: Array<string>;

  constructor(version: string, enabledFeatures: Array<string>) {
    this.version = version;
    this.enabledFeatures = enabledFeatures;
  }
}

export default class RpcService {
  static tell(aria2: Aria2, status: TaskStatus): Promise<Array<Task>> {
    return new Promise<Array<Task>>((resolve, reject) => {
      let method = "aria2.tellActive";
      let params: Array<Aria2ParamType> = [];
      switch (status) {
        case TaskStatus.active:
          method = "aria2.tellActive";
          break;
        case TaskStatus.waiting:
          method = "aria2.tellWaiting";
          params.push(0);
          params.push(1000);
          break;
        case TaskStatus.paused:
          method = "aria2.tellWaiting";
          params.push(0);
          params.push(1000);
          break;
        case TaskStatus.complete:
          method = "aria2.tellStopped";
          params.push(0);
          params.push(1000);
          break;
        case TaskStatus.error:
          method = "aria2.tellStopped";
          params.push(0);
          params.push(1000);
          break;
        case TaskStatus.removed:
          method = "aria2.tellStopped";
          params.push(0);
          params.push(1000);
          break;
      }
      params.push([
        "gid",
        "totalLength",
        "completedLength",
        "uploadSpeed",
        "downloadSpeed",
        "connections",
        "numSeeders",
        "seeder",
        "status",
        "errorCode",
        "verifiedLength",
        "verifyIntegrityPending",
        "files",
        // "dir",
        // "bitfield",
        // "numPieces",
        // "pieceLength",
        "bittorrent",
      // "infoHash"
      ]);

      RpcService.call(aria2, method, params).then(result => {
        resolve(JSONUtil.jsonToArray(Task, result.data).filter(task => task.status == status))
      }).catch((result: Result<Array<Task>>) => {
        reject(result);
      })
    });
  }

  static pauseTask(aria2: Aria2, gid: string): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      RpcService.call(aria2, "aria2.forcePause", [gid]).then(result => {
        resolve()
      }).catch((result: Result<void>) => {
        reject(result);
      })
    });
  }

  static unpauseTask(aria2: Aria2, gid: string): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      RpcService.call(aria2, "aria2.unpause", [gid]).then(result => {
        resolve()
      }).catch((result: Result<void>) => {
        reject(result);
      })
    });
  }

  static removeTask(aria2: Aria2, gid: string, force: boolean = false): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      RpcService.call(aria2, force ? "aria2.forceRemove" : "aria2.remove", [gid]).then(result => {
        resolve()
      }).catch((result: Result<void>) => {
        reject(result);
      })
    });
  }

  static removeDownloadResult(aria2: Aria2, gid: string,): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      RpcService.call(aria2, "aria2.removeDownloadResult", [gid]).then(result => {
        resolve()
      }).catch((result: Result<void>) => {
        reject(result);
      })
    });
  }

  static purgeDownloadResult(aria2: Aria2): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      RpcService.call(aria2, "aria2.purgeDownloadResult").then(result => {
        resolve()
      }).catch((result: Result<void>) => {
        reject(result);
      })
    });
  }

  static unpauseAll(aria2: Aria2): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      RpcService.call(aria2, "aria2.unpauseAll").then(result => {
        resolve()
      }).catch((result: Result<void>) => {
        reject(result);
      })
    });
  }

  static pauseAll(aria2: Aria2): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      RpcService.call(aria2, "aria2.pauseAll").then(result => {
        resolve()
      }).catch((result: Result<void>) => {
        reject(result);
      })
    });
  }

  static tellStatus(aria2: Aria2, gid: string): Promise<Task> {
    return new Promise<Task>((resolve, reject) => {
      RpcService.call(aria2, "aria2.tellStatus", [gid]).then(result => {
        resolve(JSONUtil.jsonToBean<Task>(Task, result.data)!)
      }).catch((result: Result<Task>) => {
        reject(result);
      })
    });
  }

  static getPeers(aria2: Aria2, gid: string): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      RpcService.call(aria2, "aria2.getPeers", [gid]).then(result => {
        resolve()
      }).catch((result: Result<void>) => {
        reject(result);
      })
    });
  }

  static createTask(aria2: Aria2, urls: Array<string>, options: Map<string, string>): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      RpcService.call(aria2, "aria2.addUri", [urls, options]).then(result => {
        resolve()
      }).catch((result: Result<void>) => {
        reject(result);
      })
    });
  }

  static changeTaskOption(aria2: Aria2, gid: string, options: Map<string, string>): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      RpcService.call(aria2, "aria2.changeOption", [gid, options]).then(result => {
        resolve()
      }).catch((result: Result<void>) => {
        reject(result);
      })
    });
  }

  static getGlobalOptions(aria2: Aria2): Promise<GlobalOptions> {
    return new Promise<GlobalOptions>((resolve, reject) => {
      RpcService.call(aria2, "aria2.getGlobalOption").then(result => {
        resolve(JSONUtil.jsonToBean(GlobalOptions, result.data)!)
      }).catch((result: Result<GlobalOptions>) => {
        reject(result);
      })
    });
  }

  static changeGlobalOption(aria2: Aria2, key: string, value: string): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      RpcService.call(aria2, "aria2.changeGlobalOption", [new Map<string, string>([[key, value]])]).then(result => {
        resolve()
      }).catch((result: Result<void>) => {
        reject(result);
      })
    });
  }

  static getGlobalStatus(aria2: Aria2): Promise<GlobalStatus> {
    return new Promise<GlobalStatus>((resolve, reject) => {
      RpcService.call(aria2, "aria2.getGlobalStat").then(result => {
        resolve(JSONUtil.jsonToBean(GlobalStatus, result.data)!)
      }).catch((result: Result<GlobalStatus>) => {
        reject(result);
      })
    });
  }

  static connect(aria2: Aria2): Promise<Aria2Version> {
    return new Promise<Aria2Version>((resolve, reject) => {
      RpcService.call(aria2, "aria2.getVersion").then(result => {
        resolve(JSONUtil.jsonToBean(Aria2Version, result.data)!)
      }).catch((result: Result<Aria2Version>) => {
        reject(result);
      })
    });
  }

  static call(aria2: Aria2, method: string, params?: Array<Aria2ParamType>,
    needSecret?: boolean): Promise<Result<string>> {
    return new Promise<Result<string>>((resolve, reject) => {
      let args: Array<Aria2ParamType> = [];
      if (aria2.secret != null || needSecret) {
        args.push(`token:${aria2.secret}`);
      }
      if (params) {
        args = args.concat(params);
      }
      let jsonStr = JSONUtil.beanToJsonStr({
        'jsonrpc': '2.0',
        'method': method,
        'params': args,
        'id': Aria2Utils.generateId(Const.APP_PREFIX),
        // Unique identifier for the request
      })
      let httpRequest = http.createHttp();
      httpRequest.request(
        aria2.url,
        {
          method: http.RequestMethod.POST,
          extraData: jsonStr,
        }, (err, data) => {
        if (!err) {
          if (data.responseCode == 200) {
            // console.info('Result:' + JSON.stringify(data.result));
            let aria2Response = JSONUtil.jsonToBean<Aria2Response>(Aria2Response, data.result as string)
            if (aria2Response) {
              if (aria2Response?.code) {
                reject(Result.error<string>(aria2Response.code ?? "9999",
                  aria2Response.message ?? "network error"));
              } else {
                resolve(Result.ok<string>(JSONUtil.beanToJsonStr(aria2Response.result)));
              }
              resolve(Result.error<string>("9999", "network error"))
            } else {
              reject(Result.error<string>("9999", "network error"));
            }
          } else {
            reject(Result.error<string>("9999", "network error"));
          }
        } else {
          reject(Result.error<string>(err.code.toString(), err.message));
          console.error('error:' + JSON.stringify(err));
        }
        httpRequest.destroy();
      }
      )
    }
    )
  }
}