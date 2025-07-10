# VideoDownloaderApp User Guide

## Table of Contents

1. [Getting Started](#getting-started)
2. [Installation](#installation)
3. [User Interface Overview](#user-interface-overview)
4. [How to Use](#how-to-use)
5. [Supported Websites](#supported-websites)
6. [Troubleshooting](#troubleshooting)
7. [Tips and Best Practices](#tips-and-best-practices)
8. [FAQ](#faq)

---

## Getting Started

VideoDownloaderApp is a modern, cross-platform desktop application that allows you to download videos and audio from various online platforms including YouTube, TikTok, Instagram, and many more. The app features a clean, intuitive interface with three main sections: Paste Link, Downloads, and History.

### Key Features

- ✅ **Multi-Platform Support**: Works on Windows, Linux, and macOS
- ✅ **Format Selection**: Choose from various video and audio formats
- ✅ **Progress Tracking**: Real-time download progress with speed and ETA
- ✅ **Download History**: Keep track of all your downloads
- ✅ **File Management**: Easy access to downloaded files and folders
- ✅ **Custom Naming**: Rename videos before downloading
- ✅ **Quality Options**: Select from available quality levels

---

## Installation

### Prerequisites

Before installing VideoDownloaderApp, ensure you have the following dependencies:

#### 1. .NET 8.0 Runtime
- **Windows**: Download from [Microsoft .NET Downloads](https://dotnet.microsoft.com/download/dotnet/8.0)
- **Linux**: Install via package manager or download from Microsoft
- **macOS**: Download from Microsoft or install via Homebrew

#### 2. yt-dlp
yt-dlp is the core engine that powers video downloads.

**Installation Options:**

**Windows:**
```bash
# Using winget
winget install yt-dlp

# Or download from GitHub releases
# https://github.com/yt-dlp/yt-dlp/releases
```

**Linux:**
```bash
# Using pip
pip install yt-dlp

# Or using package manager (Ubuntu/Debian)
sudo apt install yt-dlp
```

**macOS:**
```bash
# Using Homebrew
brew install yt-dlp

# Or using pip
pip install yt-dlp
```

#### 3. ffmpeg (Optional but Recommended)
ffmpeg is used for audio conversion and video processing.

**Windows:**
- Download from [ffmpeg.org](https://ffmpeg.org/download.html)
- Add to system PATH

**Linux:**
```bash
sudo apt install ffmpeg  # Ubuntu/Debian
sudo yum install ffmpeg  # CentOS/RHEL
```

**macOS:**
```bash
brew install ffmpeg
```

### Installing VideoDownloaderApp

1. **Download the Application**
   - Download the latest release for your platform from the releases page
   - Extract the archive to your preferred location

2. **Run the Application**
   - **Windows**: Double-click `VideoDownloaderApp.exe`
   - **Linux**: Run `./VideoDownloaderApp` in terminal
   - **macOS**: Open `VideoDownloaderApp.app`

---

## User Interface Overview

The application features a modern, tabbed interface with three main sections:

### Main Window Layout

```
┌─────────────────────────────────────────────────────────┐
│  VideoDownloaderApp                                     │
├─────────────────────────────────────────────────────────┤
│  [Paste Link] [Downloads] [History]                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Tab Content Area                                       │
│                                                         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 1. Paste Link Tab
This is where you start your downloads:
- **URL Input Field**: Paste video URLs here
- **Fetch Formats Button**: Retrieve available download options
- **Format Selection**: Choose video/audio quality and format
- **Download Options**: Set custom filename and save location

### 2. Downloads Tab
Monitor your active downloads:
- **Progress Bars**: Visual progress indicators
- **Download Speed**: Real-time speed information
- **Status Updates**: Current download status
- **Queue Management**: View and manage download queue

### 3. History Tab
Access your completed downloads:
- **Download List**: Chronological list of completed downloads
- **File Actions**: Play files or open containing folders
- **History Management**: Remove items from history

---

## How to Use

### Step 1: Paste a Video URL

1. **Navigate to the Paste Link tab**
2. **Copy a video URL** from your browser (YouTube, TikTok, etc.)
3. **Paste the URL** into the text field
4. **Click "Fetch Formats"** to retrieve available download options

**Example URLs:**
- YouTube: `https://www.youtube.com/watch?v=VIDEO_ID`
- TikTok: `https://www.tiktok.com/@user/video/VIDEO_ID`
- Instagram: `https://www.instagram.com/p/POST_ID/`

### Step 2: Select Format and Quality

After fetching formats, you'll see available options:

**Video Formats:**
- **MP4**: Most compatible video format
- **WEBM**: Web-optimized format
- **MKV**: High-quality container format

**Audio Formats:**
- **MP3**: Universal audio format
- **M4A**: High-quality audio
- **OPUS**: Efficient compression

**Quality Levels:**
- **Best**: Highest available quality
- **Worst**: Lowest quality (smallest file)
- **Specific Resolutions**: 1080p, 720p, 480p, etc.

### Step 3: Configure Download Settings

**Custom Filename (Optional):**
- Enter a custom name for your file
- Extension will be added automatically
- Leave blank to use original title

**Save Location:**
- Click folder icon to choose download directory
- Default location varies by operating system

### Step 4: Start Download

1. **Click "Download"** to begin
2. **Switch to Downloads tab** to monitor progress
3. **View real-time progress** including:
   - Download percentage
   - Current speed (MB/s)
   - Estimated time remaining
   - File size information

### Step 5: Access Downloaded Files

Once download completes:

1. **Check History tab** for completed downloads
2. **Click "Play"** to open file with default application
3. **Click "Open Folder"** to view file location
4. **Remove from history** if desired

---

## Supported Websites

VideoDownloaderApp supports hundreds of websites through yt-dlp. Popular sites include:

### Video Platforms
- **YouTube** - Videos, playlists, live streams
- **Vimeo** - Professional video hosting
- **Dailymotion** - European video platform
- **Twitch** - Gaming streams and clips

### Social Media
- **TikTok** - Short-form videos
- **Instagram** - Posts, stories, reels
- **Twitter/X** - Video tweets
- **Facebook** - Public videos

### Educational
- **Khan Academy** - Educational content
- **Coursera** - Course videos (where permitted)
- **edX** - Educational platform content

### News and Media
- **BBC iPlayer** - BBC content (UK)
- **CNN** - News videos
- **Reuters** - News content

### Other Platforms
- **SoundCloud** - Audio content
- **Bandcamp** - Music platform
- **Archive.org** - Internet Archive content

**Note**: Always respect copyright laws and terms of service for each platform.

---

## Troubleshooting

### Common Issues and Solutions

#### 1. "yt-dlp not found" Error

**Problem**: Application cannot locate yt-dlp executable.

**Solutions:**
- Ensure yt-dlp is installed and in system PATH
- On Windows, restart application after installing yt-dlp
- Try reinstalling yt-dlp using different method

**Verification:**
```bash
# Test yt-dlp installation
yt-dlp --version
```

#### 2. "ffmpeg not found" Warning

**Problem**: Audio conversion may not work properly.

**Solutions:**
- Install ffmpeg following installation instructions above
- Add ffmpeg to system PATH
- Restart application after installation

#### 3. Download Fails or Stalls

**Possible Causes:**
- Network connectivity issues
- Video is private or restricted
- Geographic restrictions
- Server-side rate limiting

**Solutions:**
- Check internet connection
- Try a different video URL
- Wait and retry later
- Use VPN if geographically restricted

#### 4. Format Fetching Takes Too Long

**Causes:**
- Slow internet connection
- Server response delays
- Complex playlist or long video

**Solutions:**
- Wait patiently (can take 30+ seconds)
- Check network connection
- Try simpler URLs first

#### 5. File Permission Errors

**Problem**: Cannot save to selected directory.

**Solutions:**
- Choose different save location
- Run application as administrator (Windows)
- Check folder permissions
- Ensure sufficient disk space

### Getting Help

If you encounter issues not covered here:

1. **Check Error Messages**: Read any error messages carefully
2. **Verify Dependencies**: Ensure yt-dlp and ffmpeg are properly installed
3. **Test with Simple URLs**: Try downloading from YouTube first
4. **Check Logs**: Look for detailed error information in console output
5. **Update Dependencies**: Ensure you have latest versions of yt-dlp and ffmpeg

---

## Tips and Best Practices

### Download Optimization

**Choose Appropriate Quality:**
- Use "Best" for archival purposes
- Use 720p for general viewing
- Use audio-only for music/podcasts

**Batch Downloads:**
- Queue multiple downloads
- Monitor system resources
- Consider network bandwidth

**File Organization:**
- Create dedicated download folders
- Use descriptive custom filenames
- Organize by date or category

### Performance Tips

**System Resources:**
- Close unnecessary applications during large downloads
- Ensure sufficient disk space (2x video size recommended)
- Use wired internet connection for stability

**Network Considerations:**
- Download during off-peak hours for better speeds
- Pause other network-intensive activities
- Consider download limits if on metered connection

### Legal and Ethical Usage

**Respect Copyright:**
- Only download content you have permission to download
- Respect creators' intellectual property
- Follow platform terms of service

**Fair Use:**
- Use downloads for personal, educational, or research purposes
- Don't redistribute copyrighted content
- Support content creators through official channels

---

## FAQ

### General Questions

**Q: Is VideoDownloaderApp free to use?**
A: Yes, VideoDownloaderApp is open-source and free to use.

**Q: Does it work offline?**
A: No, an internet connection is required to fetch video information and download content.

**Q: Can I download entire playlists?**
A: Currently, individual video downloads are supported. Playlist support may be added in future versions.

### Technical Questions

**Q: What video qualities are available?**
A: Available qualities depend on the source video. Common options include 4K, 1080p, 720p, 480p, and audio-only.

**Q: Can I pause and resume downloads?**
A: This feature is planned for future releases. Currently, interrupted downloads need to be restarted.

**Q: Where are downloads saved by default?**
A: Default locations:
- Windows: `%USERPROFILE%\Downloads`
- Linux: `~/Downloads`
- macOS: `~/Downloads`

**Q: Can I change the default download location?**
A: Yes, use the folder picker to select a custom location for each download.

### Troubleshooting Questions

**Q: Why do some videos fail to download?**
A: Common reasons include:
- Private or restricted videos
- Geographic restrictions
- Copyright protection
- Server-side blocking

**Q: The application is slow to start. Why?**
A: This may be due to:
- First-time dependency checking
- Antivirus scanning
- System resource constraints

**Q: Can I download age-restricted content?**
A: Age-restricted content may require authentication, which is not currently supported in the GUI version.

### Feature Questions

**Q: Will there be mobile versions?**
A: Currently, only desktop versions are available. Mobile versions are not planned.

**Q: Can I schedule downloads?**
A: Download scheduling is planned for future releases.

**Q: Is there a dark theme?**
A: The application uses your system's theme settings. Dark theme support may be enhanced in future versions.

---

## Support and Community

For additional support, updates, and community discussions:

- **GitHub Repository**: [Link to repository]
- **Issue Tracker**: Report bugs and request features
- **Documentation**: Latest guides and API documentation
- **Community Forums**: User discussions and tips

---

*This user guide is regularly updated. For the latest version, check the documentation in the GitHub repository.*
