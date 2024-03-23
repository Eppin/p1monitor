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

# License

Refer to the `License.md` for details regarding licensing.

# Credits

Thanks to the original creator of the P1-monitor software!
