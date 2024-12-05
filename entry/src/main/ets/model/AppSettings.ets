export class AppSettings {
  language: string;
  themeMode: string;
  refreshInterval: number;

  constructor(language: string, themeMode: string, refreshInterval: number) {
    this.language = language;
    this.themeMode = themeMode;
    this.refreshInterval = refreshInterval;
  }
}