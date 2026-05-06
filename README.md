# Windrose on Memory

windroseのdedicated serverでDisk I/Oが跳ねていたのでそれをオンメモリに展開するようにした。

内包しているimage
 * https://github.com/indifferentbroccoli/windrose-server-docker

## ファイル構成

```
.
├── README.md
├── archives
│   └── dailyのバックアップ置き場
├── backup_saved
│   └── 5分ごとのバックアップ
├── bin
│   ├── check_expired.sh
│   └── update_server.sh
├── data-loader
│   ├── Dockerfile
│   └── load.sh
├── data-sync
│   ├── Dockerfile
│   └── sync.sh
├── docker-compose.yml
└── .env # env_sampleを編集して配置してください
```

### check_expired.sh
ラグいときに出るログ（`Slow task`. `TimeStamp expired`）を観察したいときに実行
### update_server.sh
オンメモリのセーブデータをディスクに書き戻しつつ、イメージの更新を行う。cronで実行しておくとよし
