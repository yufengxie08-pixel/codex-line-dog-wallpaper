# Line Dog Wallpaper for Codex

[中文](#中文说明) · [English](#english)

![Line Dog wallpaper](plugins/codex-line-dog-wallpaper/assets/line-dog-wallpaper-3840x2400.jpg)

## 中文说明

把“线条小狗”插画设为 macOS Codex 桌面应用的聊天背景。壁纸为 3840×2400、16:10、sRGB，适配 MacBook Pro Retina 屏幕。插件不会修改 Codex 应用包；它通过仅监听本机回环地址的 Dream Skin 运行时加载背景。

### 安装方式一：Codex 插件

```bash
codex plugin marketplace add yufengxie08-pixel/codex-line-dog-wallpaper --ref main
codex plugin add codex-line-dog-wallpaper@line-dog-wallpaper
```

安装后在一个新的 Codex 任务中发送：`安装线条小狗聊天壁纸`。

### 安装方式二：一行命令

```bash
/bin/bash -c "$(curl -fsSL --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/yufengxie08-pixel/codex-line-dog-wallpaper/main/install.sh)"
```

### 安装方式三：双击安装

从 [Releases](https://github.com/yufengxie08-pixel/codex-line-dog-wallpaper/releases/latest) 下载 `Line-Dog-Wallpaper-Installer.zip`，解压后双击 `Install Line Dog Wallpaper.command`。如果 macOS 阻止首次打开，请右键文件并选择“打开”。

安装时会备份当前 Dream Skin 主题，并停用但不会删除 U7 自动启动项。如果 Codex 正在运行，安装器不会打断当前对话；正常退出并重新打开 Codex 一次即可生效。

### 恢复与卸载

在 Codex 中发送“恢复安装前的 Codex 主题”，或在仓库副本中运行：

```bash
plugins/codex-line-dog-wallpaper/scripts/restore-previous-macos.sh
```

双击安装包中的 `Uninstall Line Dog Wallpaper.command` 可恢复之前的主题并移除插件注册。共享的 Dream Skin 引擎和恢复备份会保留，避免破坏其他主题。

### 兼容性

- macOS，Apple Silicon 与 Intel 均为尽力支持；首发版本已在 Apple Silicon、macOS 26.5.2、Codex 26.825.51511 上验证静态结构。
- 需要已安装并至少启动过一次的官方 Codex 桌面应用。
- Codex 聊天背景不是稳定的官方主题 API；应用更新后可能需要本项目跟进适配。
- 安装器验证官方应用签名，并把调试端口限制在 `127.0.0.1`。

### 图片与许可证

插画作者：**佳期Qi**，经授权在本项目中发布。个人可下载并用作 Codex 聊天壁纸。MIT License 只覆盖代码和文档，图片条款见 [ARTWORK-LICENSE.md](ARTWORK-LICENSE.md)。

## English

Use the Line Dog illustration as the chat background in the Codex desktop app for macOS. The included wallpaper is a 3840×2400, 16:10, sRGB asset designed for MacBook Pro Retina displays. The plugin does not modify the signed Codex app bundle; it loads the background through a loopback-only Dream Skin runtime.

### Option 1: install as a Codex plugin

```bash
codex plugin marketplace add yufengxie08-pixel/codex-line-dog-wallpaper --ref main
codex plugin add codex-line-dog-wallpaper@line-dog-wallpaper
```

Then start a new Codex task and ask: `Install the Line Dog chat wallpaper.`

### Option 2: one-line installer

```bash
/bin/bash -c "$(curl -fsSL --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/yufengxie08-pixel/codex-line-dog-wallpaper/main/install.sh)"
```

### Option 3: double-click installer

Download `Line-Dog-Wallpaper-Installer.zip` from the [latest release](https://github.com/yufengxie08-pixel/codex-line-dog-wallpaper/releases/latest), unzip it, and double-click `Install Line Dog Wallpaper.command`. If Gatekeeper blocks the first launch, right-click the file and choose Open.

The installer backs up the current Dream Skin theme and disables—but does not delete—the U7 autostart agent. It never interrupts an open Codex conversation; quit and reopen Codex once after installation if the wallpaper is not already visible.

### Restore and uninstall

Ask Codex to restore the theme that was active before installation, or run:

```bash
plugins/codex-line-dog-wallpaper/scripts/restore-previous-macos.sh
```

The release bundle also includes `Uninstall Line Dog Wallpaper.command`. Uninstalling preserves the shared Dream Skin engine and recovery backup so other themes remain safe.

### Compatibility

- Best-effort support for Apple Silicon and Intel Macs. The initial release was structurally validated on Apple Silicon, macOS 26.5.2, and Codex 26.825.51511.
- Requires the official Codex desktop app to have been launched at least once.
- Chat backgrounds are not a stable public Codex theming API, so future Codex updates may require a compatibility update.
- The installer validates the official app signature and binds the debugging endpoint to `127.0.0.1` only.

### Artwork and license

Artwork by **佳期Qi**, distributed in this project with permission. Personal use as a Codex chat wallpaper is permitted. The MIT License covers software and documentation only; see [ARTWORK-LICENSE.md](ARTWORK-LICENSE.md) for the artwork terms.
