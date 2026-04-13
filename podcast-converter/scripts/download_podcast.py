import os
import sys
import subprocess
import re
import shutil
from pathlib import Path

def get_yt_dlp_path():
    """Find yt-dlp in system PATH or use a default."""
    return shutil.which("yt-dlp") or "yt-dlp"

def download_podcast(url, target_dir=None):
    if not target_dir:
        target_dir = Path.home() / "Downloads" / "Podcasts"
    
    target_dir = Path(target_dir)
    target_dir.mkdir(parents=True, exist_ok=True)
    
    yt_dlp = get_yt_dlp_path()
    
    print(f"正在从 {url} 解析播客信息...")
    
    try:
        # 1. Fetch metadata
        cmd_meta = [yt_dlp, "--get-title", "--get-description", "--get-uploader", url]
        result = subprocess.run(cmd_meta, capture_output=True, text=True, check=True)
        lines = result.stdout.strip().split('\n')
        
        title = re.sub(r'[/\\:*?"<>|]', '_', lines[0])
        description = lines[1] if len(lines) > 1 else ""
        uploader = re.sub(r'[/\\:*?"<>|]', '_', lines[2]) if len(lines) > 2 else "Podcast"
        
        # 2. Extract Podcast Name from description
        match = re.search(r'听《([^》]+)》上小宇宙', description)
        podcast_name = match.group(1) if match else uploader
        
        if not podcast_name or "xiaoyuzhoufm" in podcast_name.lower():
            podcast_name = "Podcast"
            
        filename_m4a = f"{podcast_name} - {title}.m4a"
        output_path_m4a = target_dir / filename_m4a
        
        print(f"下载中: {filename_m4a}")
        cmd_dl = [yt_dlp, "-o", str(output_path_m4a), url]
        subprocess.run(cmd_dl, check=True)
        
        if output_path_m4a.exists():
            print("已下载，正在检查格式...")
            target_mp3 = target_dir / f"{podcast_name} - {title}.mp3"
            
            # Check if it's already mp3 (some sources might download as mp3)
            # Actually yt-dlp might have downloaded it as something else if specified, 
            # but we'll assume m4a for now as per original script.
            
            print("正在转换为 MP3...")
            cmd_ffmpeg = ["ffmpeg", "-i", str(output_path_m4a), "-ab", "192k", "-ac", "2", str(target_mp3), "-y"]
            subprocess.run(cmd_ffmpeg, check=True)
            
            if target_mp3.exists():
                print(f"转换成功: {target_mp3.name}")
                os.remove(output_path_m4a)
                print(f"任务完成。文件保存在: {target_mp3}")
                return str(target_mp3)
                
    except subprocess.CalledProcessError as e:
        print(f"执行失败: {e.stderr}")
    except Exception as e:
        print(f"发生错误: {e}")
    return None

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法: python download_podcast.py [URL] [目标目录(可选)]")
        sys.exit(1)
    
    url = sys.argv[1]
    save_dir = sys.argv[2] if len(sys.argv) > 2 else None
    download_podcast(url, save_dir)
