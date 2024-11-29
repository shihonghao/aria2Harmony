import { relationalStore } from '@kit.ArkData';

export default interface DatabaseMapper<T> {

  createBucket(source: T): relationalStore.ValuesBucket;

  processResult(resultSet: relationalStore.ResultSet): Array<T>;

  table(): string;

  createPredicate(): relationalStore.RdbPredicates;

  insert(data: T): Promise<number>

  update(predicateBuilder: (predicate: relationalStore.RdbPredicates) => void, data: T): Promise<number>

  delete(predicateBuilder: (predicate: relationalStore.RdbPredicates) => void): Promise<number>

  query(predicateBuilder: (predicate: relationalStore.RdbPredicates) => void): Promise<Array<T>>

}