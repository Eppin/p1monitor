# Extract and build P1Monitor

## 1. Flash image and retrieve `requirements.txt` using an Raspberry Pi

1. Download latest version [ztatz](https://www.ztatz.nl/p1-monitor-software-archief/)
2. Flash image using you favorite tool, like `dd` (`dd if={file-name}.img  of=/dev/rdisk{n} bs=1`)
3. `source bin/activate`
4. `pip3 freeze`
5. Remove line: `pkg_resources==0.0.0`
6.

## 2. Connect downloaded image and mount to filesystem

1. `losetup -Pf p1mon{version}.img`
2. `mkdir loop0p1 && mount /dev/loop0p1 loop0p1/`
3. `mkdir loop0p2 && mount /dev/loop0p2 loop0p2/`
4. Extract `/p1mon`, TAR can be used (`tar -cf p1mon.tar /p1mon`)
5. Place the extraced folders and file in the proper places in this repository
