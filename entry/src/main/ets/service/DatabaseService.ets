import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import DatabaseMapper from '../model/DatabaseMapper';

const ARIA2_CREATED_SQL =
  "CREATE TABLE IF NOT EXISTS ARIA2 (ID INTEGER PRIMARY KEY AUTOINCREMENT,KEY TEXT UNIQUE, NAME TEXT NOT NULL, URL TEXT NOT NULL, SECRET TEXT, IS_DEFAULT INTEGER)"


class DatabaseService {
  private constructor() {
  }

  static instance: DatabaseService = new DatabaseService();
  private store?: relationalStore.RdbStore;

  init(context: Context, config: relationalStore.StoreConfig): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      relationalStore.getRdbStore(context, config, (err: BusinessError, store: relationalStore.RdbStore) => {
        if (err) {
          console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
          reject();
          return;
        }
        store.executeSql(ARIA2_CREATED_SQL, (err) => {
          if (err) {
            reject();
            return;
          }
        });
        this.store = store;
        resolve();
      });
    });
  }

  insert<T>(mapper: DatabaseMapper<T>, value: T): Promise<number> {
    return new Promise<number>((resolve, reject) => {
      let bucket = mapper.createBucket(value);
      if (!this.store) {
        reject();
        return;
      }
      this.store.insert(mapper.table(), bucket, (err, rowId) => {
        if (err) {
          console.error(`Failed to insert data. Code:${err.code}, message:${err.message}`);
          reject();
          return;
        }
        resolve(rowId);

      })

    });
  }

  update<T>(predicate: relationalStore.RdbPredicates, mapper: DatabaseMapper<T>, value: T): Promise<number> {
    return new Promise<number>((resolve, reject) => {
      let bucket = mapper.createBucket(value);
      if (!this.store) {
        reject();
        return;
      }
      this.store.update(bucket, predicate, (err, rows) => {
        if (err) {
          console.error(`Failed to update data. Code:${err.code}, message:${err.message}`);
          reject();
          return;
        }
        resolve(rows);
      })

    });

  }

  delete(predicate: relationalStore.RdbPredicates): Promise<number> {

    return new Promise<number>((resolve, reject) => {
      if (!this.store) {
        reject();
        return;
      }
      this.store.delete(predicate, (err, rows) => {
        if (err) {
          console.error(`Failed to update data. Code:${err.code}, message:${err.message}`);
          reject();
          return;
        }
        resolve(rows);
      })

    });
  }

  query<T>(predicate: relationalStore.RdbPredicates, mapper: DatabaseMapper<T>): Promise<Array<T>> {
    return new Promise<Array<T>>((resolve, reject) => {
      if (!this.store) {
        reject();
        return;
      }
      this.store.query(predicate, [], (err, resultSet) => {
        if (err) {
          console.error(`Failed to query data. Code:${err.code}, message:${err.message}`);
          reject();
          return;
        }
        resolve(mapper.processResult(resultSet));
      })
    });
  }

}


export default DatabaseService.instance;