#!/bin/bash

# 获取链接参数
URL="$1"
TARGET_DIR="/home/yunsh/.openclaw/workspace/播客"
YT_DLP="/home/yunsh/.openclaw/workspace/yt-dlp"

# 检查目录是否存在
mkdir -p "$TARGET_DIR"

echo "正在从 $URL 解析播客信息..."

# 1. 获取节目标题和频道描述
TITLE=$("$YT_DLP" --get-title "$URL" | sed 's/[/\\:*?"<>|]/_/g')
DESC=$("$YT_DLP" --get-description "$URL")

# 2. 动态提取频道名：尝试从描述中提取 (匹配模式: 听《频道名》上小宇宙)
PODCAST_NAME=$(echo "$DESC" | grep -oP '(?<=听《)[^》]+' | head -n 1)

# 如果没提取到，尝试回退到 uploader 字段
if [ -z "$PODCAST_NAME" ]; then
    PODCAST_NAME=$("$YT_DLP" --get-uploader "$URL" | sed 's/[/\\:*?"<>|]/_/g')
fi

# 如果还是空，默认用 Podcast
if [ -z "$PODCAST_NAME" ] || [[ "$PODCAST_NAME" == *"xiaoyuzhoufm"* ]]; then
    PODCAST_NAME="Podcast"
fi

FILENAME="$PODCAST_NAME - $TITLE.m4a"
OUTPUT_PATH="$TARGET_DIR/$FILENAME"

echo "下载中: $FILENAME"
"$YT_DLP" -o "$OUTPUT_PATH" "$URL"

# 3. 转换处理
if [ -f "$OUTPUT_PATH" ]; then
    echo "已下载，正在检查格式..."
    TARGET_MP3="$TARGET_DIR/$PODCAST_NAME - $TITLE.mp3"
    
    # 如果源文件已经是 mp3，直接重命名并退出
    if [[ "$FILENAME" == *.mp3 ]]; then
        mv "$OUTPUT_PATH" "$TARGET_MP3"
        echo "文件已是 MP3 格式: $TARGET_MP3"
        FINAL_FILE="$TARGET_MP3"
    else
        echo "正在转换为 MP3..."
        ffmpeg -i "$OUTPUT_PATH" -ab 192k -ac 2 "$TARGET_MP3" -y
        
        # 仅在转换成功后删除源文件
        if [ -f "$TARGET_MP3" ]; then
            echo "转换成功，正在清理原始文件: $FILENAME"
            rm "$OUTPUT_PATH"
            FINAL_FILE="$TARGET_MP3"
        fi
    fi
fi

# 任务完成通知及清单
echo "✅ 任务全部完成。"
echo "📝 本次处理文件清单:"
ls -lh "$FINAL_FILE"
