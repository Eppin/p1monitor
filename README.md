# P1-monitor

![License](https://img.shields.io/badge/License-AGPLv3-blue.svg)

## Disclaimer

This project is a Dockerized container running the original P1-monitor software from [ztatz](https://www.ztatz.nl/p1-monitor/). Since the original P1-monitor software is only available as a dedicated Raspberry Pi image. Most of the original software has been extracted from the Raspberry Pi image, however some pages may be added in the future and bugs that'll be found, will be fixed (also check the `patch` folder, it contains some changes).

Mainly I work on this project for personal purposes, because I like to develop in my freetime (as a fulltime fullstack .NET developer). While my goal is to keep it working for everyone, I can't and won't guarantee it will. If you run into any issues, just let me know and I'll try to help.

## Support

Please beware this project is NOT officially supported by [ztatz](https://www.ztatz.nl/p1-monitor/), however there is a [forum](https://forum.p1mon.nl/) to visit.

## Docker usage

The easiest way to get started, is by using the `docker-compose.yaml` that's available in this repository. If you'd like, change the image tag, ports and/or USB device.

`docker compose up -d`

### Device usage

Since the USB device can change and be different after a reboot or physical port change, these step will create link based on the physical properties.

Find your device with `lsusb` and take a note of the ID. The vendor is **0403** and the product is **6001**

```
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 002: ID 0403:6001 Future Technology Devices International, Ltd FT232 Serial (UART) IC
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

Now that we have the needed information, let's create the symbolic link:

`nano /etc/udev/rules.d/50-myusb.rules`

```
KERNEL=="ttyUSB[0-9]*", SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666", SYMLINK+="p1mon"
```

Make sure to replace the `idVendor` and `idProduct` values with your own! Save the file and reboot the system. Now you have a symbolic link `/dev/p1mon`, which can be passed through in the Docker container.

# License

Refer to the `License.md` for details regarding licensing.

# Credits

Thanks to the original creator of the P1-monitor software!
