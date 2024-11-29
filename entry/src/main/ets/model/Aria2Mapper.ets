import Aria2 from './Aria2';
import DatabaseMapper from './DatabaseMapper';
import { relationalStore } from '@kit.ArkData';
import DatabaseService from '../service/DatabaseService';

class Aria2Mapper implements DatabaseMapper<Aria2> {
  static instance: Aria2Mapper = new Aria2Mapper();

  private constructor() {
  }

  insert(data: Aria2): Promise<number> {
    return DatabaseService.insert<Aria2>(this, data);
  }

  update(predicateBuilder: (predicate: relationalStore.RdbPredicates) => void, data: Aria2): Promise<number> {
    let predicate = this.createPredicate();
    predicateBuilder(predicate);
    return DatabaseService.update<Aria2>(predicate, this, data);
  }

  delete(predicateBuilder: (predicate: relationalStore.RdbPredicates) => void): Promise<number> {
    let predicate = this.createPredicate();
    predicateBuilder(predicate);
    return DatabaseService.delete(predicate);
  }

  query(predicateBuilder: (predicate: relationalStore.RdbPredicates) => void): Promise<Aria2[]> {
    let predicate = this.createPredicate();
    predicateBuilder(predicate);
    return DatabaseService.query<Aria2>(predicate, this);
  }

  createPredicate(): relationalStore.RdbPredicates {
    return new relationalStore.RdbPredicates(this.table());
  }

  table(): string {
    return 'ARIA2'
  }

  createBucket(source: Aria2): relationalStore.ValuesBucket {
    return {
      KEY: source.key,
      NAME: source.name,
      URL: source.url,
      SECRET: source.secret,
      IS_DEFAULT: source.isDefault ? 1 : 0
    }
  }

  processResult(resultSet: relationalStore.ResultSet): Array<Aria2> {
    let arr: Array<Aria2> = [];
    while (resultSet.goToNextRow()) {
      arr.push(new Aria2(
        resultSet.getString(resultSet.getColumnIndex('KEY')),
        resultSet.getString(resultSet.getColumnIndex('NAME')),
        resultSet.getString(resultSet.getColumnIndex('URL')),
        resultSet.getString(resultSet.getColumnIndex('SECRET')),
        resultSet.getLong(resultSet.getColumnIndex('IS_DEFAULT')) == 1
      ))

    }
    return arr;
  }
}

export default Aria2Mapper.instance;