# Podcast Downloader & Converter (Auto)

Automated tool to download podcasts from various platforms (optimized for Xiaoyuzhou FM) and convert them to MP3 locally.

## Setup

1. Ensure `yt-dlp` and `ffmpeg` are installed on the host system.
2. The skill supports automated channel name extraction from metadata.

## Usage

### Local CLI
```bash
./download_podcast.sh [URL]
```

### WeChat / Auto-Mode
1. Send a podcast URL directly to the OpenClaw WeChat bot.
2. The bot will automatically trigger the `download_podcast.sh` script.
3. Bot will notify you upon successful conversion to MP3.

## Workflow
1. **Fetch Metadata**: Extracts Channel Name and Episode Title via `yt-dlp`.
2. **Download**: Saves as `.m4a` or `.mp3` with format: `Channel - Title`.
3. **Convert**: If source is not `.mp3`, uses `ffmpeg` to transcode to 192kbps stereo MP3.
4. **Cleanup**: Automatically deletes non-MP3 original files after successful conversion.

## Security
- Runs locally (no LLM token consumption for audio processing).
- Automated via chat hooks.
