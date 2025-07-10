# VideoDownloaderApp

![App Screenshot](https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg?auto=compress&cs=tinysrgb&w=800&h=400&fit=crop)

A modern, cross-platform desktop application built with **C# .NET 8.0** and **Avalonia UI** for downloading videos and audio from popular platforms like YouTube, TikTok, Instagram, and hundreds of other websites. Features a clean, intuitive interface with real-time progress tracking and comprehensive download management.

## 🌟 Key Features

### Core Functionality
- ✅ **Multi-Platform Support**: Native apps for Windows, Linux, and macOS
- ✅ **Universal Compatibility**: Supports 1000+ websites via yt-dlp integration
- ✅ **Format Selection**: Choose from various video qualities and audio formats
- ✅ **Real-Time Progress**: Live download progress with speed and ETA tracking
- ✅ **Smart History**: Comprehensive download history with file management
- ✅ **Custom Naming**: Rename files before downloading
- ✅ **Flexible Storage**: Choose custom download locations

### Modern User Experience
- 🎨 **Modern UI**: Clean, responsive interface with Fluent design
- 🚀 **Fast Performance**: Asynchronous operations keep UI responsive
- 📱 **Intuitive Navigation**: Tabbed interface for easy workflow
- 🎯 **Error Handling**: Graceful error management with user feedback
- 🔧 **File Integration**: Direct file access and folder opening

## 📸 Screenshots

### Main Interface
![Main Interface](https://images.pexels.com/photos/1181298/pexels-photo-1181298.jpeg?auto=compress&cs=tinysrgb&w=800&h=500&fit=crop)

*Clean, tabbed interface with Paste Link, Downloads, and History sections*

### Download Progress
![Download Progress](https://images.pexels.com/photos/590016/pexels-photo-590016.jpg?auto=compress&cs=tinysrgb&w=800&h=500&fit=crop)

*Real-time progress tracking with speed and status indicators*

## 🏗️ Architecture Overview

VideoDownloaderApp follows the **MVVM (Model-View-ViewModel)** pattern for clean separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                    VideoDownloaderApp                       │
├─────────────────────────────────────────────────────────────┤
│  Views (AXAML + Code-behind)                               │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │ MainWindow  │ │ PasteLinkView│ │DownloadsView│          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
│           │              │              │                  │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │   MainVM    │ │ PasteLinkVM │ │DownloadsVM  │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
├─────────────────────────────────────────────────────────────┤
│  Services: YtDlpService, FileService                       │
├─────────────────────────────────────────────────────────────┤
│  Models: DownloadItem, HistoryItem                          │
├─────────────────────────────────────────────────────────────┤
│  External: yt-dlp, ffmpeg                                  │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
VideoDownloaderApp/
├── 📁 Models/
│   ├── 📄 DownloadItem.cs      # Active download representation
│   └── 📄 HistoryItem.cs       # Completed download record
├── 📁 ViewModels/
│   ├── 📄 MainViewModel.cs     # Main window coordinator
│   ├── 📄 PasteLinkViewModel.cs # URL input and format fetching
│   ├── 📄 DownloadsViewModel.cs # Download queue management
│   └── 📄 HistoryViewModel.cs   # Download history management
├── 📁 Views/
│   ├── 📄 MainWindow.axaml     # Main application window
│   ├── 📄 PasteLinkView.axaml  # URL input interface
│   ├── 📄 DownloadsView.axaml  # Active downloads monitor
│   └── 📄 HistoryView.axaml    # Download history browser
├── 📁 Services/
│   ├── 📄 YtDlpService.cs      # yt-dlp CLI integration
│   └── 📄 FileService.cs       # File system operations
├── 📁 Resources/
│   ├── 🖼️ logo.png             # Application logo
│   └── 🎬 splash.gif           # Splash screen animation
└── 📁 docs/
    ├── 📖 Architecture.md      # Detailed architecture guide
    ├── 📖 API_Documentation.md # Complete API reference
    └── 📖 User_Guide.md        # Comprehensive user manual
```

## 🚀 Quick Start

### Prerequisites

**Required Dependencies:**
- [.NET 8.0 SDK](https://dotnet.microsoft.com/download/dotnet/8.0) or later
- [yt-dlp](https://github.com/yt-dlp/yt-dlp/releases) - Video download engine
- [ffmpeg](https://ffmpeg.org/download.html) - Media processing (optional but recommended)

### Installation

#### Windows
```powershell
# Install .NET 8.0
winget install Microsoft.DotNet.SDK.8

# Install yt-dlp
winget install yt-dlp

# Install ffmpeg
winget install ffmpeg
```

#### Linux (Ubuntu/Debian)
```bash
# Install .NET 8.0
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update && sudo apt install dotnet-sdk-8.0

# Install yt-dlp and ffmpeg
sudo apt install yt-dlp ffmpeg
```

#### macOS
```bash
# Install .NET 8.0
brew install dotnet

# Install yt-dlp and ffmpeg
brew install yt-dlp ffmpeg
```

### Building and Running

```bash
# Clone and navigate to project
cd VideoDownloaderApp

# Restore dependencies
dotnet restore

# Build the application
dotnet build

# Run the application
dotnet run
```

### Publishing for Distribution

```bash
# Windows (x64)
dotnet publish -c Release -r win-x64 --self-contained -p:PublishSingleFile=true

# Linux (x64)
dotnet publish -c Release -r linux-x64 --self-contained -p:PublishSingleFile=true

# macOS (x64)
dotnet publish -c Release -r osx-x64 --self-contained -p:PublishSingleFile=true

# macOS (ARM64 - Apple Silicon)
dotnet publish -c Release -r osx-arm64 --self-contained -p:PublishSingleFile=true
```

## 📖 Usage Guide

### 1. Paste Link Tab - Start Your Download
![Paste Link Interface](https://images.pexels.com/photos/1181677/pexels-photo-1181677.jpeg?auto=compress&cs=tinysrgb&w=600&h=300&fit=crop)

1. **Paste URL**: Copy any supported video URL and paste it into the text field
2. **Fetch Formats**: Click to retrieve available download options
3. **Select Format**: Choose your preferred video quality or audio format
4. **Customize**: Optionally rename the file and choose save location
5. **Download**: Start the download process

### 2. Downloads Tab - Monitor Progress
![Download Progress](https://images.pexels.com/photos/590016/pexels-photo-590016.jpg?auto=compress&cs=tinysrgb&w=600&h=300&fit=crop)

- **Real-time Progress**: Visual progress bars with percentage completion
- **Speed Monitoring**: Current download speed and estimated time remaining
- **Status Tracking**: Clear status indicators (Pending, Downloading, Complete, Failed)
- **Queue Management**: View and manage multiple simultaneous downloads

### 3. History Tab - Access Your Downloads
![Download History](https://images.pexels.com/photos/1181298/pexels-photo-1181298.jpeg?auto=compress&cs=tinysrgb&w=600&h=300&fit=crop)

- **Complete History**: Chronological list of all completed downloads
- **Quick Actions**: Play files directly or open containing folders
- **File Management**: Remove items from history as needed
- **Easy Access**: One-click access to downloaded content

## 🌐 Supported Platforms

VideoDownloaderApp supports **1000+ websites** through yt-dlp integration:

### Popular Video Platforms
- **YouTube** - Videos, playlists, live streams, shorts
- **Vimeo** - Professional video hosting platform
- **Dailymotion** - European video sharing platform
- **Twitch** - Gaming streams, clips, and VODs

### Social Media Platforms
- **TikTok** - Short-form vertical videos
- **Instagram** - Posts, stories, reels, IGTV
- **Twitter/X** - Video tweets and embedded content
- **Facebook** - Public videos and live streams

### Educational Platforms
- **Khan Academy** - Educational video content
- **Coursera** - Course videos (where permitted)
- **edX** - Educational platform content
- **YouTube Education** - Educational channels

### News and Media
- **BBC iPlayer** - BBC content (UK region)
- **CNN** - News video content
- **Reuters** - International news videos
- **Associated Press** - News media content

### Audio Platforms
- **SoundCloud** - Music and podcast content
- **Bandcamp** - Independent music platform
- **Mixcloud** - DJ mixes and radio shows

*And hundreds more! See the [complete list](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md) of supported sites.*

## 🛠️ Technical Details

### Core Technologies
- **Framework**: .NET 8.0 with C# 12
- **UI Framework**: Avalonia UI 11.3.2 (Cross-platform XAML)
- **Architecture**: MVVM with CommunityToolkit.Mvvm 8.2.1
- **Theming**: Fluent Design with Inter font family
- **CLI Integration**: yt-dlp and ffmpeg via System.Diagnostics.Process

### Key Features Implementation
- **Asynchronous Operations**: All network and file operations use async/await
- **Real-time Updates**: INotifyPropertyChanged and ObservableCollection for live UI updates
- **Cross-platform File Operations**: Platform-specific file system integration
- **Error Handling**: Comprehensive error management with user-friendly messages
- **Process Management**: Safe external process execution with proper cleanup

### Performance Optimizations
- **Non-blocking UI**: All long-running operations run on background threads
- **Memory Efficient**: Proper disposal of resources and process cleanup
- **Responsive Design**: Adaptive UI that works on various screen sizes
- **Efficient Data Binding**: Compiled bindings for improved performance

## 🔧 Development

### Setting Up Development Environment

```bash
# Clone the repository
git clone [repository-url]
cd VideoDownloaderApp

# Install dependencies
dotnet restore

# Run in development mode
dotnet run

# Run with hot reload (if supported)
dotnet watch run
```

### Adding New Features

1. **Models**: Create data models in `Models/` folder
2. **Services**: Implement business logic in `Services/` folder
3. **ViewModels**: Add view models in `ViewModels/` folder with proper MVVM patterns
4. **Views**: Design UI in `Views/` folder using AXAML
5. **Testing**: Add unit tests for new functionality

### Code Style Guidelines
- Follow C# naming conventions
- Use async/await for all I/O operations
- Implement INotifyPropertyChanged for data binding
- Add XML documentation comments for public APIs
- Use dependency injection where appropriate

## 📚 Documentation

### For Users
- **[User Guide](docs/User_Guide.md)** - Complete user manual with step-by-step instructions
- **[Troubleshooting](docs/User_Guide.md#troubleshooting)** - Common issues and solutions
- **[FAQ](docs/User_Guide.md#faq)** - Frequently asked questions

### For Developers
- **[Architecture Guide](docs/Architecture.md)** - Detailed architectural overview
- **[API Documentation](docs/API_Documentation.md)** - Complete API reference
- **[Contributing Guidelines](#contributing)** - How to contribute to the project

## 🐛 Troubleshooting

### Common Issues

**"yt-dlp not found" Error**
```bash
# Verify yt-dlp installation
yt-dlp --version

# Add to PATH or place in application directory
```

**Download Failures**
- Check internet connection
- Verify URL is accessible
- Try different video quality/format
- Check for geographic restrictions

**Performance Issues**
- Close unnecessary applications
- Ensure sufficient disk space
- Use wired internet connection for large downloads

For detailed troubleshooting, see the [User Guide](docs/User_Guide.md#troubleshooting).

## 🚧 Roadmap

### Version 2.0 (Planned)
- [ ] **Batch Downloads**: Download multiple videos simultaneously
- [ ] **Playlist Support**: Download entire playlists with one click
- [ ] **Download Scheduling**: Schedule downloads for specific times
- [ ] **Auto-clipboard Detection**: Automatically detect video URLs in clipboard

### Version 2.1 (Future)
- [ ] **Pause/Resume**: Pause and resume downloads
- [ ] **Download Presets**: Save preferred quality/format settings
- [ ] **Advanced Filtering**: Filter downloads by duration, size, etc.
- [ ] **Subtitle Downloads**: Download subtitles with videos

### Version 3.0 (Long-term)
- [ ] **Plugin System**: Extensible architecture for custom downloaders
- [ ] **Cloud Integration**: Save directly to cloud storage
- [ ] **Media Library**: Built-in media organization and playback
- [ ] **Mobile Companion**: Mobile app for remote control

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Getting Started
1. **Fork** the repository
2. **Clone** your fork locally
3. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
4. **Make** your changes
5. **Test** thoroughly
6. **Commit** your changes (`git commit -m 'Add amazing feature'`)
7. **Push** to your branch (`git push origin feature/amazing-feature`)
8. **Open** a Pull Request

### Contribution Guidelines
- Follow existing code style and conventions
- Add tests for new functionality
- Update documentation as needed
- Ensure cross-platform compatibility
- Test on multiple operating systems if possible

### Types of Contributions
- 🐛 **Bug Fixes**: Fix issues and improve stability
- ✨ **New Features**: Add new functionality
- 📖 **Documentation**: Improve guides and API docs
- 🎨 **UI/UX**: Enhance user interface and experience
- 🔧 **Performance**: Optimize speed and resource usage

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

### Third-Party Licenses
- **yt-dlp**: [Unlicense](https://github.com/yt-dlp/yt-dlp/blob/master/LICENSE)
- **ffmpeg**: [LGPL/GPL](https://ffmpeg.org/legal.html)
- **Avalonia UI**: [MIT License](https://github.com/AvaloniaUI/Avalonia/blob/master/licence.md)

## 🙏 Acknowledgments

- **[yt-dlp team](https://github.com/yt-dlp/yt-dlp)** - Powerful video download engine
- **[Avalonia UI](https://avaloniaui.net/)** - Cross-platform .NET UI framework
- **[FFmpeg](https://ffmpeg.org/)** - Multimedia processing framework
- **[.NET Foundation](https://dotnetfoundation.org/)** - .NET ecosystem support

## 📞 Support

- **📖 Documentation**: Check our comprehensive [docs](docs/) folder
- **🐛 Bug Reports**: Open an issue on GitHub
- **💡 Feature Requests**: Suggest new features via GitHub issues
- **❓ Questions**: Start a discussion on GitHub Discussions

---

<div align="center">

**Made with ❤️ using .NET and Avalonia UI**

[⭐ Star this repo](../../stargazers) | [🐛 Report Bug](../../issues) | [💡 Request Feature](../../issues) | [📖 Documentation](docs/)

</div>

