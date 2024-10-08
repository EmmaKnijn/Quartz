# Quartz

DFPWM and MDFPWM audio player for ComputerCraft.

![quartz](https://github.com/Ale32bit/Quartz/assets/4512372/3d22b768-e024-4c88-b40c-e9598ad37853)

## Installation

Quartz can be installed by executing the `download.lua` file or by copy pasting this command:

```
wget run https://raw.github.com/Ale32bit/Quartz/main/download.lua
```

## Usage

Run the `player.lua` program and insert a disk containing a .dfpwm or a .mdfpwm file.

### Controls

| Key       | Description                         |
| --------- | ----------------------------------- |
| Space     | Play/Pause/Resume                   |
| S         | Stop                                |
| Left      | Backward 5 seconds                  |
| Right     | Forward 5 seconds                   |
| Up        | Volume up                           |
| Down      | Volume down                         |
| Page Up   | Distance Up                         |
| Page Down | Distance Down                       |
| F1        | Toggle log screen (keys still work) |

## Configuration

Quartz can be configured with the use of the `set` command.

| Key                    | Description                                                                                                                                                     | Type    | Default                  |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | ------------------------ |
| `quartz.left`          | Left channel speaker, can be a side of the computer or a network name.                                                                                          | string  | `left`                   |
| `quartz.right`         | Right channel speaker, can be a side of the computer or a network name.                                                                                         | string  | `right`                  |
| `quartz.volume`        | Volume of the audio, must be a float number between 0.0 and 1.0.                                                                                                | number  | `1.0`                    |
| `quartz.distance`      | The range of the audio, must be an integer number between 0 and 128.                                                                                            | number  | `1`                      |
| `quartz.loop`          | Replays the audio track when it ends.                                                                                                                           | boolean | `true`                   |
| `quartz.autoplay`      | Automatically plays the disk when the program is started.                                                                                                       | boolean | `true`                   |
| `quartz.distributed`   | Play mono audio on all speakers attached to the network. This setting disables `quartz.left` and `quartz.right`. Fine tune `quartz.distance` for best coverage. | boolean | `false`                  |
| `quartz.raw`           | Skip the audio filters when decoding DFPWM.                                                                                                                     | boolean | `false`                  |
| `quartz.stream.server` | Server URL of the conversion service. No trailing slash.                                                                                                        | string  | `https://cc.alexdevs.me` |
| `quartz.stream.navidromeShares` | Enable Navidrome shares support | boolean | `true` |