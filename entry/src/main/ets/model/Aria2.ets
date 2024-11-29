export default class Aria2 {
  public key: string;
  public name: string;
  public url: string;
  public secret: string;
  public isDefault: boolean;

  constructor(key: string, name: string, url: string, secret?: string, isDefault?: boolean) {
    this.key = key;
    this.name = name;
    this.url = url;
    this.secret = secret ?? "";
    this.isDefault = isDefault ?? false;

  }
}