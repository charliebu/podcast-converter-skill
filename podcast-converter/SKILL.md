---
name: podcast-converter
description: 自动从各类平台（特别优化小宇宙）下载播客并转换为高质量 MP3。当用户提供播客链接（如小宇宙 URL）并请求下载或转换时，使用此 Skill。
---

# Podcast Downloader & Converter

此 Skill 能够自动化执行从播客链接到本地 MP3 文件的完整处理流程。

## ⚙️ 环境依赖

使用前请确保主机已安装：
- **Python 3.10+**
- **yt-dlp**: 用于解析和下载音频。
- **ffmpeg**: 用于音频转码。

## 🚀 工作流指令

当接收到播客链接时，请遵循以下步骤：

### 1. 自动处理同步
直接运行内置的 Python 脚本。脚本会自动提取频道名、下载音频并转码为 192kbps 立体声 MP3。

```powershell
python "scripts/download_podcast.py" "[PODCAST_URL]"
```

### 2. 跨平台工具对照
| 功能 | Gemini CLI | Claude Code | 逻辑描述 |
| :--- | :--- | :--- | :--- |
| 执行脚本 | `run_shell_command` | `Bash` | 运行下载与转换脚本 |
| 文件路径 | Windows/Linux 兼容 | Windows/Linux 兼容 | 使用 `pathlib` 自动处理 |

## 🛠️ 核心功能
1. **元数据提取**：自动从播客描述中识别频道名（例如：“听《XXX》上小宇宙”）。
2. **智能命名**：以 `[频道名] - [节目标题].mp3` 格式保存。
3. **自动清理**：转码成功后自动删除原始的 `.m4a` 或其他中间格式文件。
4. **默认路径**：默认保存至用户目录下的 `Downloads/Podcasts`。

## 🔒 安全与隐私
- **本地运行**：所有音频处理均在本地完成，不消耗 LLM Token。
- **无隐私泄露**：不包含任何硬编码的用户路径或凭证。
