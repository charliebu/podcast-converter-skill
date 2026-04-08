#!/bin/bash

# 获取脚本所在目录
DIR="${1:-.}"

# 遍历目录下的所有 .m4a 文件
for file in "$DIR"/*.m4a; do
    # 检查是否有 .m4a 文件
    [ -e "$file" ] || continue
    
    # 定义输出文件名 (将 .m4a 替换为 .mp3)
    output="${file%.m4a}.mp3"
    
    echo "正在转换: $file -> $output"
    
    # 使用 ffmpeg 转换
    # -i: 输入文件
    # -ab 192k: 设置比特率为 192kbps (高质量)
    # -ac 2: 设置声道为立体声
    ffmpeg -i "$file" -ab 192k -ac 2 "$output" -y
done

echo "所有转换完成。"
