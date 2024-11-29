import { Base64Util, StrUtil } from '@pura/harmony-utils';
import Aria2 from '../model/Aria2';
import Aria2Mapper from '../model/Aria2Mapper';
import { Aria2Keys } from '../static/PersistentKeys';

export class Aria2Utils {
  static generateId(prefix: string): string {
    let sourceId = prefix + '_' + Math.round(new Date().getTime() / 1000) + '_' + Math.random();
    let hashedId = Base64Util.encodeToStrSync(StrUtil.strToUint8Array(sourceId));
    return hashedId;
  }

  static addAria2(aria2: Aria2): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      Aria2Mapper.insert(aria2).then(() => {
        AppStorage.get<Map<string, Aria2>>(Aria2Keys.ARIA2S)?.set(aria2.key, aria2)
        resolve();
      }).catch(() => {
        reject;
      })
    })
  }

  static updateAria2(newAria2: Aria2): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      Aria2Mapper.update((predicate => {
        predicate.equalTo('key', newAria2.key)
      }), newAria2).then(() => {
        AppStorage.get<Map<string, Aria2>>(Aria2Keys.ARIA2S)?.set(newAria2.key, newAria2);
        resolve();
      }).catch(() => {
        reject;
      });
    });
  }

  static removeAria2(aria2: Aria2): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      Aria2Mapper.delete((predicate => {
        predicate.equalTo('key', aria2.key)
      })).then(() => {
        AppStorage.get<Map<string, Aria2>>(Aria2Keys.ARIA2S)?.delete(aria2.key);
        resolve();
      }).catch(() => {
        reject;
      });
    });
  }
}