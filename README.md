# Line Dog Full Skin Collection for Codex

[中文](#中文说明) · [English](#english)

| 黄色相伴（默认） | 蓝天追风 |
| --- | --- |
| ![黄色相伴](plugins/codex-line-dog-wallpaper/assets/line-dog-yellow-together-3840x2400.jpg) | ![蓝天追风](plugins/codex-line-dog-wallpaper/assets/line-dog-blue-sky-3840x2400.jpg) |
| 蓝色日常 | 粉色伙伴 |
| ![蓝色日常](plugins/codex-line-dog-wallpaper/assets/line-dog-blue-daily-3840x2400.jpg) | ![粉色伙伴](plugins/codex-line-dog-wallpaper/assets/line-dog-pink-friends-3840x2400.jpg) |

## 中文说明

把四张“线条小狗”插画变成 macOS Codex 桌面应用的完整皮肤。每张壁纸都拥有独立的明暗配色，覆盖侧栏、标题栏、内容区、输入框、按钮、菜单、弹窗与选中状态；同时配有小狗、爪印、骨头等专属图标。全部壁纸均为 3840×2400、16:10、sRGB，适配 MacBook Pro Retina 屏幕；首次安装默认使用“黄色相伴”。插件不会修改 Codex 应用包，而是通过仅监听本机回环地址的 Dream Skin 运行时加载皮肤。

### 完整皮肤与无遮挡回复

壁纸会贯穿整个 Codex 窗口，侧栏、输入框、工具卡片和弹窗使用低透明度“糖纸玻璃”表面。最终的 Codex 助手回复不显示大块白色圆角背景，文字直接呈现在壁纸上，并带有轻微阴影以维持可读性；代码块、文件预览和工具结果仍有清晰边界。皮肤会自动跟随 Codex 的明暗模式。所有效果只在本项目的线条小狗主题中启用，不会改变 U7 或其他 Dream Skin 主题。

### 安装方式一：Codex 插件

```bash
codex plugin marketplace add yufengxie08-pixel/codex-line-dog-wallpaper --ref main
codex plugin add codex-line-dog-wallpaper@line-dog-wallpaper
```

安装后新建一个 Codex 任务并发送：`安装线条小狗完整皮肤`。

### 安装方式二：一行命令

```bash
/bin/bash -c "$(curl -fsSL --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/yufengxie08-pixel/codex-line-dog-wallpaper/main/install.sh)"
```

### 安装方式三：双击安装

从 [Releases](https://github.com/yufengxie08-pixel/codex-line-dog-wallpaper/releases/latest) 下载 `Line-Dog-Wallpaper-Installer.zip`，解压后双击 `Install Line Dog Wallpaper.command`。如果 macOS 阻止首次打开，请右键文件并选择“打开”。

安装时会备份当前 Dream Skin 主题，并停用但不会删除 U7 自动启动项。如果 Codex 正在运行，安装器不会打断当前对话；壁纸没有立即显示时，正常退出并重新打开 Codex 一次即可。

### 在 Codex 里切换壁纸

在 Codex 聊天框发送：`切换线条小狗皮肤`（发送“切换线条小狗壁纸”也可以）。

“线条小狗壁纸选择器”技能会在对话中展示四张图片，并标出当前和默认皮肤。选中后，壁纸、明暗配色、玻璃控件和图标会一起切换；如果当前 Codex 没有安全的热切换端点，插件会提示并自动重启一次。也可以直接运行：

```bash
plugins/codex-line-dog-wallpaper/scripts/select-wallpaper-macos.sh blue-sky --restart-if-needed
```

可用 ID：`yellow-together`、`blue-sky`、`blue-daily`、`pink-friends`。

### 单独下载壁纸

- [黄色相伴](https://github.com/yufengxie08-pixel/codex-line-dog-wallpaper/releases/latest/download/Line-Dog-Yellow-Together-3840x2400.jpg)
- [蓝天追风](https://github.com/yufengxie08-pixel/codex-line-dog-wallpaper/releases/latest/download/Line-Dog-Blue-Sky-3840x2400.jpg)
- [蓝色日常](https://github.com/yufengxie08-pixel/codex-line-dog-wallpaper/releases/latest/download/Line-Dog-Blue-Daily-3840x2400.jpg)
- [粉色伙伴](https://github.com/yufengxie08-pixel/codex-line-dog-wallpaper/releases/latest/download/Line-Dog-Pink-Friends-3840x2400.jpg)

### 恢复与卸载

在 Codex 中发送“恢复安装前的 Codex 主题”，或运行：

```bash
plugins/codex-line-dog-wallpaper/scripts/restore-previous-macos.sh
```

双击安装包中的 `Uninstall Line Dog Wallpaper.command` 可恢复之前的主题并移除插件注册。线条小狗的独立运行时和恢复备份会保留，避免破坏其他主题。

### 兼容性

- macOS，Apple Silicon 与 Intel 均为尽力支持；在 Apple Silicon、macOS 26.5.2、Codex 26.825.51511 上完成结构验证。
- 需要已安装并至少启动过一次的官方 Codex 桌面应用。
- Codex 聊天背景不是稳定的官方主题 API；应用更新后可能需要本项目跟进适配。
- 安装器验证官方应用签名，并把调试端口限制在 `127.0.0.1`。

### 图片与许可证

四张插画作者均为 **佳期Qi**，经授权在本项目中发布。个人可下载并用作 Codex 聊天壁纸。MIT License 只覆盖代码和文档，图片条款见 [ARTWORK-LICENSE.md](ARTWORK-LICENSE.md)。

## English

Turn four Line Dog illustrations into complete skins for the Codex desktop app on macOS. Each wallpaper has its own light and dark palette across the sidebar, header, content, composer, controls, menus, dialogs, and selected states, plus purpose-built dog, paw, chat, bone, and clock icons. Every wallpaper is a 3840×2400, 16:10, sRGB asset designed for MacBook Pro Retina displays. New installations default to Yellow Together. The plugin does not modify the signed Codex app bundle; it loads the skin through a loopback-only Dream Skin runtime.

### Complete skin and unobstructed replies

The wallpaper spans the full Codex window while the sidebar, composer, tool cards, and overlays use low-opacity candy-glass surfaces. Final assistant replies do not use a large opaque rounded surface; their text appears directly over the wallpaper with a subtle readability shadow. Code, file previews, and tool results retain clear boundaries. The skin follows Codex light and dark modes automatically and does not alter U7 or other Dream Skin themes.

### Option 1: install as a Codex plugin

```bash
codex plugin marketplace add yufengxie08-pixel/codex-line-dog-wallpaper --ref main
codex plugin add codex-line-dog-wallpaper@line-dog-wallpaper
```

Start a new Codex task and ask: `Install the Line Dog full skin.`

### Option 2: one-line installer

```bash
/bin/bash -c "$(curl -fsSL --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/yufengxie08-pixel/codex-line-dog-wallpaper/main/install.sh)"
```

### Option 3: double-click installer

Download `Line-Dog-Wallpaper-Installer.zip` from the [latest release](https://github.com/yufengxie08-pixel/codex-line-dog-wallpaper/releases/latest), unzip it, and double-click `Install Line Dog Wallpaper.command`. If Gatekeeper blocks the first launch, right-click the file and choose Open.

The installer backs up the current Dream Skin theme and disables—but does not delete—the U7 autostart agent. It never interrupts an open Codex conversation; quit and reopen Codex once if the skin is not already visible.

### Switch wallpapers inside Codex

Send `Switch the Line Dog skin` in Codex (`Switch the Line Dog wallpaper` also works). The selector displays all four previews and marks the current and default choices. Wallpaper, palette, glass surfaces, and icons switch together. It hot-switches when possible and, with a warning, automatically restarts Codex once when required.

You can also switch directly:

```bash
plugins/codex-line-dog-wallpaper/scripts/select-wallpaper-macos.sh pink-friends --restart-if-needed
```

Valid IDs are `yellow-together`, `blue-sky`, `blue-daily`, and `pink-friends`.

### Download individual wallpapers

- [Yellow Together](https://github.com/yufengxie08-pixel/codex-line-dog-wallpaper/releases/latest/download/Line-Dog-Yellow-Together-3840x2400.jpg)
- [Blue Sky Adventure](https://github.com/yufengxie08-pixel/codex-line-dog-wallpaper/releases/latest/download/Line-Dog-Blue-Sky-3840x2400.jpg)
- [Blue Daily Life](https://github.com/yufengxie08-pixel/codex-line-dog-wallpaper/releases/latest/download/Line-Dog-Blue-Daily-3840x2400.jpg)
- [Pink Friends](https://github.com/yufengxie08-pixel/codex-line-dog-wallpaper/releases/latest/download/Line-Dog-Pink-Friends-3840x2400.jpg)

### Restore and uninstall

Ask Codex to restore the theme that was active before installation, or run:

```bash
plugins/codex-line-dog-wallpaper/scripts/restore-previous-macos.sh
```

The release bundle also includes `Uninstall Line Dog Wallpaper.command`. Uninstalling preserves the isolated Line Dog runtime and recovery backup so other themes remain safe.

### Compatibility

- Best-effort support for Apple Silicon and Intel Macs. Structurally validated on Apple Silicon, macOS 26.5.2, and Codex 26.825.51511.
- Requires the official Codex desktop app to have been launched at least once.
- Complete skins are not a stable public Codex theming API, so future Codex updates may require a compatibility update.
- The installer validates the official app signature and binds the debugging endpoint to `127.0.0.1` only.

### Artwork and license

All four illustrations are by **佳期Qi** and are distributed in this project with permission. Personal use as Codex chat wallpapers is permitted. The MIT License covers software and documentation only; see [ARTWORK-LICENSE.md](ARTWORK-LICENSE.md) for the artwork terms.
