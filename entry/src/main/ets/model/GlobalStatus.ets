import { Transform } from "class-transformer";
import { convertToNumber } from "./GlobalOptions";

export default class GlobalStatus {
  @Transform(convertToNumber)
  downloadSpeed: number;
  @Transform(convertToNumber)
  uploadSpeed: number;
  @Transform(convertToNumber)
  numActive: number;
  @Transform(convertToNumber)
  numWaiting: number;
  @Transform(convertToNumber)
  numStopped: number;
  @Transform(convertToNumber)
  numStoppedTotal: number;

  constructor(downloadSpeed: number, uploadSpeed: number, numActive: number, numWaiting: number, numStopped: number,
    numStoppedTotal: number) {
    this.downloadSpeed = downloadSpeed;
    this.uploadSpeed = uploadSpeed;
    this.numActive = numActive;
    this.numWaiting = numWaiting;
    this.numStopped = numStopped;
    this.numStoppedTotal = numStoppedTotal;
  }
}