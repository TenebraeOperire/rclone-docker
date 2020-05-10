[appurl]: https://rclone.org/

# rclone-docker

Another docker for [rclone][appurl] -- aka "rsync for cloud storage" -- a command line program to sync files and directories to and from different cloud storage providers.

**Cloud Services**
* Amazon Drive
* Amazon S3
* Backblaze B2
* Box
* Dropbox
* FTP
* Google Drive
* Microsoft OneDrive
* The local filesystem
* [And more][appurl]  

**Features**

-   MD5/SHA-1 hashes checked at all times for file integrity
-   Timestamps preserved on files
-   Partial syncs supported on a whole file basis
-   [Copy](https://rclone.org/commands/rclone_copy/) mode to just copy new/changed files
-   [Sync](https://rclone.org/commands/rclone_sync/) (one way) mode to make a directory identical
-   [Check](https://rclone.org/commands/rclone_check/) mode to check for file hash equality
-   Can sync to and from network, e.g. two different cloud accounts
-   Optional large file chunking ([Chunker](https://rclone.org/chunker/))
-   Optional encryption ([Crypt](https://rclone.org/crypt/))
-   Optional cache ([Cache](https://rclone.org/cache/))
-   Optional FUSE mount ([rclone mount](https://rclone.org/commands/rclone_mount/))
-   Multi-threaded downloads to local disk
-   Can [serve](https://rclone.org/commands/rclone_serve/) local or remote files over HTTP/WebDav/FTP/SFTP/dlna

## Usage

The docker expects a file named rclone_cron to exist in container path /config
On startup, cron schedules from this file are activated within the container
Example cron to run a sync from /data to remote:path at 3am every day:
```
0 3 * * * rclone sync --config=/config/rclone.conf /data remote:path
```

**Parameters**
* `-v /config` The path to rclone.conf and rclone_cron files
* `-v /data` The path to the data that rclone will back up

## Info

* Unraid template included

## Versions

+ **2020.05.10**
  * Initial beta release
