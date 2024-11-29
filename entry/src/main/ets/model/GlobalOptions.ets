import { Expose, Transform, TransformFnParams } from 'class-transformer';
import "reflect-metadata";

export  function convertToNumber(param: TransformFnParams) {
  if (typeof param.value == 'string') {
    return Number(param.value);
  } else {
    return String(param.value);
  }
}

export  function convertToBool(param: TransformFnParams) {
  if (typeof param.value == 'string') {
    return param.value == 'true';
  } else {
    return param.value ? 'true' : 'false'
  }
}

export default class GlobalOptions {
  version?: string;
  dir?: string;
  log?: string;
  @Expose({
    name: 'all-proxy'
  })
  allProxy?: string;
  @Expose({
    name: 'all-proxy-user'
  })
  allProxyUser?: string;
  @Expose({
    name: 'all-proxy-passwd'
  }) allProxyPasswd?: string;
  @Expose({
    name: 'netrc-path'
  }) netrcPath?: string;
  @Expose({
    name: 'no-proxy'
  }) noProxy?: string;
  @Expose({
    name: 'proxy-method'
  }) proxyMethod?: string;
  @Expose({
    name: 'server-stat-of'
  }) serverStatOf?: string;
  @Expose({
    name: 'stream-piece-selector'
  }) streamPieceSelector?: string;
  @Expose({
    name: 'uri-selector'
  }) uriSelector?: string;
  @Expose({
    name: 'http-user'
  }) httpUser?: string;
  @Expose({
    name: 'http-passwd'
  }) httpPasswd?: string;
  @Expose({
    name: 'http-proxy'
  }) httpProxy?: string;
  @Expose({
    name: 'http-proxy-user'
  }) httpProxyUser?: string;
  @Expose({
    name: 'http-proxy-passwd'
  }) httpProxyPasswd?: string;
  @Expose({
    name: 'https-passwd'
  }) httpsPasswd?: string;
  @Expose({
    name: 'https-proxy'
  }) httpsProxy?: string;
  @Expose({
    name: 'https-proxy-user'
  }) httpsProxyUser?: string;
  @Expose({
    name: 'https-proxy-passwd'
  }) httpsProxyPasswd?: string;
  @Expose({
    name: 'referer'
  }) referer?: string;
  @Expose({
    name: 'header'
  }) header?: string;
  @Expose({
    name: 'save-cookies'
  }) saveCookies?: string;
  @Expose({
    name: 'user-agent'
  }) userAgent?: string;
  @Expose({
    name: 'ftp-user'
  }) ftpUser?: string;
  @Expose({
    name: 'ftp-passwd'
  }) ftpPasswd?: string;
  @Expose({
    name: 'ftp-proxy'
  }) ftpProxy?: string;
  @Expose({
    name: 'ftp-proxy-user'
  }) ftpProxyUser?: string;
  @Expose({
    name: 'ftp-proxy-passwd'
  }) ftpProxyPasswd?: string;
  @Expose({
    name: 'ftp-type'
  }) ftpType?: string;
  @Expose({
    name: 'ssh-host-key-m-d'
  }) sshHostKeyMD?: string;
  @Expose({
    name: 'bt-exclude-tracker'
  }) btExcludeTracker?: string;
  @Expose({
    name: 'bt-external-ip'
  }) btExternalIp?: string;
  @Expose({
    name: 'bt-min-crypto-level'
  }) btMinCryptoLevel?: string;
  @Expose({
    name: 'bt-prioritize-piece'
  }) btPrioritizePiece?: string;
  @Expose({
    name: 'bt-tracker'
  }) btTracker?: string;
  @Expose({
    name: 'dht-file-path'
  }) dhtFilePath?: string;
  @Expose({
    name: 'dht-file-path6'
  }) dhtFilePath6?: string;
  @Expose({
    name: 'dht-listen-port'
  }) dhtListenPort?: string;
  @Expose({
    name: 'peer-id-prefix'
  }) peerIdPrefix?: string;
  @Expose({
    name: 'peer-agent'
  }) peerAgent?: string;
  @Expose({
    name: 'metalink-base-url'
  }) metalinkBaseUrl?: string;
  @Expose({
    name: 'metalink-language'
  }) metalinkLanguage?: string;
  @Expose({
    name: 'metalink-location'
  }) metalinkLocation?: string;
  @Expose({
    name: 'metalink-os'
  }) metalinkOs?: string;
  @Expose({
    name: 'metalink-version'
  }) metalinkVersion?: string;
  @Expose({
    name: 'metalink-preferred-protocol'
  }) metalinkPreferredProtocol?: string;
  @Expose({
    name: 'conf-path'
  }) confPath?: string;
  @Expose({
    name: 'console-log-level'
  }) consoleLogLevel?: string;
  @Expose({
    name: 'download-result'
  }) downloadResult?: string;
  @Expose({
    name: 'event-poll'
  }) eventPoll?: string;
  @Expose({
    name: 'file-allocation'
  }) fileAllocation?: string;
  @Expose({
    name: 'min-tls-version'
  }) minTlsVersion?: string;
  @Expose({
    name: 'log-level'
  }) logLevel?: string;
  @Expose({
    name: 'save-session'
  }) saveSession?: string;
  @Expose({
    name: 'max-concurrent-downloads'
  }) @Transform(convertToNumber) maxConcurrentDownloads?: number;
  @Expose({
    name: 'connect-timeout'
  }) @Transform(convertToNumber) connectTimeout?: number;
  @Expose({
    name: 'lowest-speed-limit'
  }) @Transform(convertToNumber) lowestSpeedLimit?: number;
  @Expose({
    name: 'max-connection-per-server'
  }) @Transform(convertToNumber) maxConnectionPerServer?: number;
  @Expose({
    name: 'max-file-not-found'
  }) @Transform(convertToNumber) maxFileNotFound?: number;
  @Expose({
    name: 'max-tries'
  }) @Transform(convertToNumber) maxTries?: number;
  @Expose({
    name: 'min-split-size'
  }) @Transform(convertToNumber) minSplitSize?: number;
  @Expose({
    name: 'retry-wait'
  }) @Transform(convertToNumber) retryWait?: number;
  @Expose({
    name: 'server-stat-timeout'
  }) @Transform(convertToNumber) serverStatTimeout?: number;
  @Expose({
    name: 'split'
  }) @Transform(convertToNumber) split?: number;
  @Expose({
    name: 'timeout'
  }) @Transform(convertToNumber) timeout?: number;
  @Expose({
    name: 'bt-max-open-files'
  }) @Transform(convertToNumber) btMaxOpenFiles?: number;
  @Expose({
    name: 'bt-max-peers'
  }) @Transform(convertToNumber) btMaxPeers?: number;
  @Expose({
    name: 'bt-request-peer-speed-limit'
  }) @Transform(convertToNumber) btRequestPeerSpeedLimit?: number;
  @Expose({
    name: 'bt-stop-time-out'
  }) @Transform(convertToNumber) btStopTimeOut?: number;
  @Expose({
    name: 'bt-tracker-connect-timeout'
  }) @Transform(convertToNumber) btTrackerConnectTimeout?: number;
  @Expose({
    name: 'bt-tracker-interval'
  }) @Transform(convertToNumber) btTrackerInterval?: number;
  @Expose({
    name: 'bt-tracker-timeout'
  }) @Transform(convertToNumber) btTrackerTimeout?: number;
  @Expose({
    name: 'dht-message-timeout'
  }) @Transform(convertToNumber) dhtMessageTimeout?: number;
  @Expose({
    name: 'listen-port'
  }) @Transform(convertToNumber) listenPort?: number;
  @Expose({
    name: 'max-overall-upload-limit'
  }) @Transform(convertToNumber) maxOverallUploadLimit?: number;
  @Expose({
    name: 'max-upload-limit'
  }) @Transform(convertToNumber) maxUploadLimit?: number;
  @Expose({
    name: 'rpc-listen-port'
  }) @Transform(convertToNumber) rpcListenPort?: number;
  @Expose({
    name: 'rpc-max-request-size'
  }) @Transform(convertToNumber) rpcMaxRequestSize?: number;
  @Expose({
    name: 'auto-save-interval'
  }) @Transform(convertToNumber) autoSaveInterval?: number;
  @Expose({
    name: 'disk-cache'
  }) @Transform(convertToNumber) diskCache?: number;
  @Expose({
    name: 'dscp'
  }) @Transform(convertToNumber) dscp?: number;
  @Expose({
    name: 'rlimit-nofile'
  }) @Transform(convertToNumber) rlimitNofile?: number;
  @Expose({
    name: 'max-download-result'
  }) @Transform(convertToNumber) maxDownloadResult?: number;
  @Expose({
    name: 'max-mmap-limit'
  }) @Transform(convertToNumber) maxMmapLimit?: number;
  @Expose({
    name: 'max-resume-failure-tries'
  }) @Transform(convertToNumber) maxResumeFailureTries?: number;
  @Expose({
    name: 'piece-length'
  }) @Transform(convertToNumber) pieceLength?: number;
  @Expose({
    name: 'summary-interval'
  }) @Transform(convertToNumber) summaryInterval?: number;
  @Expose({
    name: 'max-overall-download-limit'
  }) @Transform(convertToNumber) maxOverallDownloadLimit?: number;
  @Expose({
    name: 'max-download-limit'
  }) @Transform(convertToNumber) maxDownloadLimit?: number;
  @Expose({
    name: 'no-file-allocation-limit'
  }) @Transform(convertToNumber) noFileAllocationLimit?: number;
  @Expose({
    name: 'save-session-interval'
  }) @Transform(convertToNumber) saveSessionInterval?: number;
  @Expose({
    name: 'socket-recv-buffer-size'
  }) @Transform(convertToNumber) socketRecvBufferSize?: number;
  @Expose({
    name: 'stop'
  }) @Transform(convertToNumber) stop?: number;
  @Expose({
    name: 'seed-ratio'
  }) @Transform(convertToNumber) seedRatio?: number;
  @Expose({
    name: 'seed-time',
  }) @Transform(convertToNumber) seedTime?: number;
  @Expose({
    name: 'check-integrity'
  }) @Transform(convertToBool) checkIntegrity?: boolean;
  @Expose({
    name: 'continue-download'
  }) @Transform(convertToBool) continueDownload?: boolean;
  @Expose({
    name: 'dry-run'
  }) @Transform(convertToBool) dryRun?: boolean;
  @Expose({
    name: 'no-netrc'
  }) @Transform(convertToBool) noNetrc?: boolean;
  @Expose({
    name: 'remote-time'
  }) @Transform(convertToBool) remoteTime?: boolean;
  @Expose({
    name: 'reuse-uri'
  }) @Transform(convertToBool) reuseUri?: boolean;
  @Expose({
    name: 'check-certificate'
  }) @Transform(convertToBool) checkCertificate?: boolean;
  @Expose({
    name: 'http-accept-g-zip'
  }) @Transform(convertToBool) httpAcceptGZip?: boolean;
  @Expose({
    name: 'http-auth-challenge'
  }) @Transform(convertToBool) httpAuthChallenge?: boolean;
  @Expose({
    name: 'http-no-cache'
  }) @Transform(convertToBool) httpNoCache?: boolean;
  @Expose({
    name: 'enable-http-keep-alive'
  }) @Transform(convertToBool) enableHttpKeepAlive?: boolean;
  @Expose({
    name: 'enable-http-pipelining'
  }) @Transform(convertToBool) enableHttpPipelining?: boolean;
  @Expose({
    name: 'use-head'
  }) @Transform(convertToBool) useHead?: boolean;
  @Expose({
    name: 'ftp-passive'
  }) @Transform(convertToBool) ftpPassive?: boolean;
  @Expose({
    name: 'ftp-reuse-connection'
  }) @Transform(convertToBool) ftpReuseConnection?: boolean;
  @Expose({
    name: 'bt-detach-seed-only'
  }) @Transform(convertToBool) btDetachSeedOnly?: boolean;
  @Expose({
    name: 'bt-enable-hook-after-hash-check'
  }) @Transform(convertToBool) btEnableHookAfterHashCheck?: boolean;
  @Expose({
    name: 'bt-enable-lpd'
  }) @Transform(convertToBool) btEnableLpd?: boolean;
  @Expose({
    name: 'bt-force-encryption'
  }) @Transform(convertToBool) btForceEncryption?: boolean;
  @Expose({
    name: 'bt-hash-check-seed'
  }) @Transform(convertToBool) btHashCheckSeed?: boolean;
  @Expose({
    name: 'bt-load-saved-metadata'
  }) @Transform(convertToBool) btLoadSavedMetadata?: boolean;
  @Expose({
    name: 'bt-metadata-only'
  }) @Transform(convertToBool) btMetadataOnly?: boolean;
  @Expose({
    name: 'bt-remove-unselected-file'
  }) @Transform(convertToBool) btRemoveUnselectedFile?: boolean;
  @Expose({
    name: 'bt-require-crypto'
  }) @Transform(convertToBool) btRequireCrypto?: boolean;
  @Expose({
    name: 'bt-save-metadata'
  }) @Transform(convertToBool) btSaveMetadata?: boolean;
  @Expose({
    name: 'bt-seed-unverified'
  }) @Transform(convertToBool) btSeedUnverified?: boolean;
  @Expose({
    name: 'enable-dht'
  }) @Transform(convertToBool) enableDht?: boolean;
  @Expose({
    name: 'enable-dht6'
  }) @Transform(convertToBool) enableDht6?: boolean;
  @Expose({
    name: 'enable-peer-exchange'
  }) @Transform(convertToBool) enablePeerExchange?: boolean;
  @Expose({
    name: 'follow-torrent'
  }) @Transform(convertToBool) followTorrent?: boolean;
  @Expose({
    name: 'follow-meta-link'
  }) @Transform(convertToBool) followMetaLink?: boolean;
  @Expose({
    name: 'metalink-enable-unique-protocol'
  }) @Transform(convertToBool) metalinkEnableUniqueProtocol?: boolean;
  @Expose({
    name: 'enable-rpc'
  }) @Transform(convertToBool) enableRpc?: boolean;
  @Expose({
    name: 'rpc-allow-origin-all'
  }) @Transform(convertToBool) rpcAllowOriginAll?: boolean;
  @Expose({
    name: 'rpc-listen-all'
  }) @Transform(convertToBool) rpcListenAll?: boolean;
  @Expose({
    name: 'rpc-save-upload-metadata'
  }) @Transform(convertToBool) rpcSaveUploadMetadata?: boolean;
  @Expose({
    name: 'rpc-secure'
  }) @Transform(convertToBool) rpcSecure?: boolean;
  @Expose({
    name: 'pause-metadata'
  }) @Transform(convertToBool) pauseMetadata?: boolean;
  @Expose({
    name: 'allow-overwrite'
  }) @Transform(convertToBool) allowOverwrite?: boolean;
  @Expose({
    name: 'allow-piece-length-change'
  }) @Transform(convertToBool) allowPieceLengthChange?: boolean;
  @Expose({
    name: 'always-resume'
  }) @Transform(convertToBool) alwaysResume?: boolean;
  @Expose({
    name: 'async-dns'
  }) @Transform(convertToBool) asyncDns?: boolean;
  @Expose({
    name: 'auto-file-renaming'
  }) @Transform(convertToBool) autoFileRenaming?: boolean;
  @Expose({
    name: 'conditional-get'
  }) @Transform(convertToBool) conditionalGet?: boolean;
  @Expose({
    name: 'content-disposition-default-utf8'
  }) @Transform(convertToBool) contentDispositionDefaultUtf8?: boolean;
  @Expose({
    name: 'daemon'
  }) @Transform(convertToBool) daemon?: boolean;
  @Expose({
    name: 'deferred-input'
  }) @Transform(convertToBool) deferredInput?: boolean;
  @Expose({
    name: 'disable-ipv6'
  }) @Transform(convertToBool) disableIpv6?: boolean;
  @Expose({
    name: 'enable-color'
  }) @Transform(convertToBool) enableColor?: boolean;
  @Expose({
    name: 'enable-mmap'
  }) @Transform(convertToBool) enableMmap?: boolean;
  @Expose({
    name: 'force-save'
  }) @Transform(convertToBool) forceSave?: boolean;
  @Expose({
    name: 'save-not-found'
  }) @Transform(convertToBool) saveNotFound?: boolean;
  @Expose({
    name: 'hash-check-only'
  }) @Transform(convertToBool) hashCheckOnly?: boolean;
  @Expose({
    name: 'human-readable'
  }) @Transform(convertToBool) humanReadable?: boolean;
  @Expose({
    name: 'keep-unfinished-download-result'
  }) @Transform(convertToBool) keepUnfinishedDownloadResult?: boolean;
  @Expose({
    name: 'optimize-concurrent-downloads'
  }) @Transform(convertToBool) optimizeConcurrentDownloads?: boolean;
  @Expose({
    name: 'show-console-readout'
  }) @Transform(convertToBool) showConsoleReadout?: boolean;
  @Expose({
    name: 'no-conf'
  }) @Transform(convertToBool) noConf?: boolean;
  @Expose({
    name: 'parameterized-uri'
  }) @Transform(convertToBool) parameterizedUri?: boolean;
  @Expose({
    name: 'quiet'
  }) @Transform(convertToBool) quiet?: boolean;
  @Expose({
    name: 'realtime-chunk-checksum'
  }) @Transform(convertToBool) realtimeChunkChecksum?: boolean;
  @Expose({
    name: 'remove-control-file'
  }) @Transform(convertToBool) removeControlFile?: boolean;
  @Expose({
    name: 'truncate-console-readout'
  }) @Transform(convertToBool) truncateConsoleReadout?: boolean;
  @Expose({
    name: 'enabled-features'
  }) enabledFeatures?: Array<string>;

  constructor(version: string, dir: string, log: string, allProxy: string, allProxyUser: string, allProxyPasswd: string,
    netrcPath: string, noProxy: string, proxyMethod: string, serverStatOf: string, streamPieceSelector: string,
    uriSelector: string, httpUser: string, httpPasswd: string, httpProxy: string, httpProxyUser: string,
    httpProxyPasswd: string, httpsPasswd: string, httpsProxy: string, httpsProxyUser: string, httpsProxyPasswd: string,
    referer: string, header: string, saveCookies: string, userAgent: string, ftpUser: string, ftpPasswd: string,
    ftpProxy: string, ftpProxyUser: string, ftpProxyPasswd: string, ftpType: string, sshHostKeyMD: string,
    btExcludeTracker: string, btExternalIp: string, btMinCryptoLevel: string, btPrioritizePiece: string,
    btTracker: string, dhtFilePath: string, dhtFilePath6: string, dhtListenPort: string, peerIdPrefix: string,
    peerAgent: string, metalinkBaseUrl: string, metalinkLanguage: string, metalinkLocation: string, metalinkOs: string,
    metalinkVersion: string, metalinkPreferredProtocol: string, confPath: string, consoleLogLevel: string,
    downloadResult: string, eventPoll: string, fileAllocation: string, minTlsVersion: string, logLevel: string,
    saveSession: string, maxConcurrentDownloads: number, connectTimeout: number, lowestSpeedLimit: number,
    maxConnectionPerServer: number, maxFileNotFound: number, maxTries: number, minSplitSize: number, retryWait: number,
    serverStatTimeout: number, split: number, timeout: number, btMaxOpenFiles: number, btMaxPeers: number,
    btRequestPeerSpeedLimit: number, btStopTimeOut: number, btTrackerConnectTimeout: number, btTrackerInterval: number,
    btTrackerTimeout: number, dhtMessageTimeout: number, listenPort: number, maxOverallUploadLimit: number,
    maxUploadLimit: number, rpcListenPort: number, rpcMaxRequestSize: number, autoSaveInterval: number,
    diskCache: number, dscp: number, rlimitNofile: number, maxDownloadResult: number, maxMmapLimit: number,
    maxResumeFailureTries: number, pieceLength: number, summaryInterval: number, maxOverallDownloadLimit: number,
    maxDownloadLimit: number, noFileAllocationLimit: number, saveSessionInterval: number, socketRecvBufferSize: number,
    stop: number, seedRatio: number, seedTime: number, checkIntegrity: boolean, continueDownload: boolean,
    dryRun: boolean, noNetrc: boolean, remoteTime: boolean, reuseUri: boolean, checkCertificate: boolean,
    httpAcceptGZip: boolean, httpAuthChallenge: boolean, httpNoCache: boolean, enableHttpKeepAlive: boolean,
    enableHttpPipelining: boolean, useHead: boolean, ftpPassive: boolean, ftpReuseConnection: boolean,
    btDetachSeedOnly: boolean, btEnableHookAfterHashCheck: boolean, btEnableLpd: boolean, btForceEncryption: boolean,
    btHashCheckSeed: boolean, btLoadSavedMetadata: boolean, btMetadataOnly: boolean, btRemoveUnselectedFile: boolean,
    btRequireCrypto: boolean, btSaveMetadata: boolean, btSeedUnverified: boolean, enableDht: boolean,
    enableDht6: boolean, enablePeerExchange: boolean, followTorrent: boolean, followMetaLink: boolean,
    metalinkEnableUniqueProtocol: boolean, enableRpc: boolean, rpcAllowOriginAll: boolean, rpcListenAll: boolean,
    rpcSaveUploadMetadata: boolean, rpcSecure: boolean, pauseMetadata: boolean, allowOverwrite: boolean,
    allowPieceLengthChange: boolean, alwaysResume: boolean, asyncDns: boolean, autoFileRenaming: boolean,
    conditionalGet: boolean, contentDispositionDefaultUtf8: boolean, daemon: boolean, deferredInput: boolean,
    disableIpv6: boolean, enableColor: boolean, enableMmap: boolean, forceSave: boolean, saveNotFound: boolean,
    hashCheckOnly: boolean, humanReadable: boolean, keepUnfinishedDownloadResult: boolean,
    optimizeConcurrentDownloads: boolean, showConsoleReadout: boolean, noConf: boolean, parameterizedUri: boolean,
    quiet: boolean, realtimeChunkChecksum: boolean, removeControlFile: boolean, truncateConsoleReadout: boolean,
    enabledFeatures: Array<string>) {
    this.version = version;
    this.dir = dir;
    this.log = log;
    this.allProxy = allProxy;
    this.allProxyUser = allProxyUser;
    this.allProxyPasswd = allProxyPasswd;
    this.netrcPath = netrcPath;
    this.noProxy = noProxy;
    this.proxyMethod = proxyMethod;
    this.serverStatOf = serverStatOf;
    this.streamPieceSelector = streamPieceSelector;
    this.uriSelector = uriSelector;
    this.httpUser = httpUser;
    this.httpPasswd = httpPasswd;
    this.httpProxy = httpProxy;
    this.httpProxyUser = httpProxyUser;
    this.httpProxyPasswd = httpProxyPasswd;
    this.httpsPasswd = httpsPasswd;
    this.httpsProxy = httpsProxy;
    this.httpsProxyUser = httpsProxyUser;
    this.httpsProxyPasswd = httpsProxyPasswd;
    this.referer = referer;
    this.header = header;
    this.saveCookies = saveCookies;
    this.userAgent = userAgent;
    this.ftpUser = ftpUser;
    this.ftpPasswd = ftpPasswd;
    this.ftpProxy = ftpProxy;
    this.ftpProxyUser = ftpProxyUser;
    this.ftpProxyPasswd = ftpProxyPasswd;
    this.ftpType = ftpType;
    this.sshHostKeyMD = sshHostKeyMD;
    this.btExcludeTracker = btExcludeTracker;
    this.btExternalIp = btExternalIp;
    this.btMinCryptoLevel = btMinCryptoLevel;
    this.btPrioritizePiece = btPrioritizePiece;
    this.btTracker = btTracker;
    this.dhtFilePath = dhtFilePath;
    this.dhtFilePath6 = dhtFilePath6;
    this.dhtListenPort = dhtListenPort;
    this.peerIdPrefix = peerIdPrefix;
    this.peerAgent = peerAgent;
    this.metalinkBaseUrl = metalinkBaseUrl;
    this.metalinkLanguage = metalinkLanguage;
    this.metalinkLocation = metalinkLocation;
    this.metalinkOs = metalinkOs;
    this.metalinkVersion = metalinkVersion;
    this.metalinkPreferredProtocol = metalinkPreferredProtocol;
    this.confPath = confPath;
    this.consoleLogLevel = consoleLogLevel;
    this.downloadResult = downloadResult;
    this.eventPoll = eventPoll;
    this.fileAllocation = fileAllocation;
    this.minTlsVersion = minTlsVersion;
    this.logLevel = logLevel;
    this.saveSession = saveSession;
    this.maxConcurrentDownloads = maxConcurrentDownloads;
    this.connectTimeout = connectTimeout;
    this.lowestSpeedLimit = lowestSpeedLimit;
    this.maxConnectionPerServer = maxConnectionPerServer;
    this.maxFileNotFound = maxFileNotFound;
    this.maxTries = maxTries;
    this.minSplitSize = minSplitSize;
    this.retryWait = retryWait;
    this.serverStatTimeout = serverStatTimeout;
    this.split = split;
    this.timeout = timeout;
    this.btMaxOpenFiles = btMaxOpenFiles;
    this.btMaxPeers = btMaxPeers;
    this.btRequestPeerSpeedLimit = btRequestPeerSpeedLimit;
    this.btStopTimeOut = btStopTimeOut;
    this.btTrackerConnectTimeout = btTrackerConnectTimeout;
    this.btTrackerInterval = btTrackerInterval;
    this.btTrackerTimeout = btTrackerTimeout;
    this.dhtMessageTimeout = dhtMessageTimeout;
    this.listenPort = listenPort;
    this.maxOverallUploadLimit = maxOverallUploadLimit;
    this.maxUploadLimit = maxUploadLimit;
    this.rpcListenPort = rpcListenPort;
    this.rpcMaxRequestSize = rpcMaxRequestSize;
    this.autoSaveInterval = autoSaveInterval;
    this.diskCache = diskCache;
    this.dscp = dscp;
    this.rlimitNofile = rlimitNofile;
    this.maxDownloadResult = maxDownloadResult;
    this.maxMmapLimit = maxMmapLimit;
    this.maxResumeFailureTries = maxResumeFailureTries;
    this.pieceLength = pieceLength;
    this.summaryInterval = summaryInterval;
    this.maxOverallDownloadLimit = maxOverallDownloadLimit;
    this.maxDownloadLimit = maxDownloadLimit;
    this.noFileAllocationLimit = noFileAllocationLimit;
    this.saveSessionInterval = saveSessionInterval;
    this.socketRecvBufferSize = socketRecvBufferSize;
    this.stop = stop;
    this.seedRatio = seedRatio;
    this.seedTime = seedTime ?? 0;
    this.checkIntegrity = checkIntegrity;
    this.continueDownload = continueDownload;
    this.dryRun = dryRun;
    this.noNetrc = noNetrc;
    this.remoteTime = remoteTime;
    this.reuseUri = reuseUri;
    this.checkCertificate = checkCertificate;
    this.httpAcceptGZip = httpAcceptGZip;
    this.httpAuthChallenge = httpAuthChallenge;
    this.httpNoCache = httpNoCache;
    this.enableHttpKeepAlive = enableHttpKeepAlive;
    this.enableHttpPipelining = enableHttpPipelining;
    this.useHead = useHead;
    this.ftpPassive = ftpPassive;
    this.ftpReuseConnection = ftpReuseConnection;
    this.btDetachSeedOnly = btDetachSeedOnly;
    this.btEnableHookAfterHashCheck = btEnableHookAfterHashCheck;
    this.btEnableLpd = btEnableLpd;
    this.btForceEncryption = btForceEncryption;
    this.btHashCheckSeed = btHashCheckSeed;
    this.btLoadSavedMetadata = btLoadSavedMetadata;
    this.btMetadataOnly = btMetadataOnly;
    this.btRemoveUnselectedFile = btRemoveUnselectedFile;
    this.btRequireCrypto = btRequireCrypto;
    this.btSaveMetadata = btSaveMetadata;
    this.btSeedUnverified = btSeedUnverified;
    this.enableDht = enableDht;
    this.enableDht6 = enableDht6;
    this.enablePeerExchange = enablePeerExchange;
    this.followTorrent = followTorrent;
    this.followMetaLink = followMetaLink;
    this.metalinkEnableUniqueProtocol = metalinkEnableUniqueProtocol;
    this.enableRpc = enableRpc;
    this.rpcAllowOriginAll = rpcAllowOriginAll;
    this.rpcListenAll = rpcListenAll;
    this.rpcSaveUploadMetadata = rpcSaveUploadMetadata;
    this.rpcSecure = rpcSecure;
    this.pauseMetadata = pauseMetadata;
    this.allowOverwrite = allowOverwrite;
    this.allowPieceLengthChange = allowPieceLengthChange;
    this.alwaysResume = alwaysResume;
    this.asyncDns = asyncDns;
    this.autoFileRenaming = autoFileRenaming;
    this.conditionalGet = conditionalGet;
    this.contentDispositionDefaultUtf8 = contentDispositionDefaultUtf8;
    this.daemon = daemon;
    this.deferredInput = deferredInput;
    this.disableIpv6 = disableIpv6;
    this.enableColor = enableColor;
    this.enableMmap = enableMmap;
    this.forceSave = forceSave;
    this.saveNotFound = saveNotFound;
    this.hashCheckOnly = hashCheckOnly;
    this.humanReadable = humanReadable;
    this.keepUnfinishedDownloadResult = keepUnfinishedDownloadResult;
    this.optimizeConcurrentDownloads = optimizeConcurrentDownloads;
    this.showConsoleReadout = showConsoleReadout;
    this.noConf = noConf;
    this.parameterizedUri = parameterizedUri;
    this.quiet = quiet;
    this.realtimeChunkChecksum = realtimeChunkChecksum;
    this.removeControlFile = removeControlFile;
    this.truncateConsoleReadout = truncateConsoleReadout;
    this.enabledFeatures = enabledFeatures;
  }
}