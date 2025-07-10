# VideoDownloaderApp Architecture Documentation

## Overview

VideoDownloaderApp is a cross-platform desktop application built using the **MVVM (Model-View-ViewModel)** architectural pattern with **Avalonia UI** framework and **C# .NET 8.0**. The application enables users to download videos and audio from various online platforms using `yt-dlp` and `ffmpeg`.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    VideoDownloaderApp                       │
├─────────────────────────────────────────────────────────────┤
│  Views (AXAML + Code-behind)                               │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │ MainWindow  │ │ PasteLinkView│ │DownloadsView│          │
│  │             │ │             │ │             │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
│           │              │              │                  │
│           ▼              ▼              ▼                  │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │   MainVM    │ │ PasteLinkVM │ │DownloadsVM  │          │
│  │             │ │             │ │             │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
├─────────────────────────────────────────────────────────────┤
│  Services Layer                                            │
│  ┌─────────────┐ ┌─────────────┐                          │
│  │ YtDlpService│ │ FileService │                          │
│  │             │ │             │                          │
│  └─────────────┘ └─────────────┘                          │
├─────────────────────────────────────────────────────────────┤
│  Models                                                    │
│  ┌─────────────┐ ┌─────────────┐                          │
│  │DownloadItem │ │ HistoryItem │                          │
│  │             │ │             │                          │
│  └─────────────┘ └─────────────┘                          │
├─────────────────────────────────────────────────────────────┤
│  External Dependencies                                     │
│  ┌─────────────┐ ┌─────────────┐                          │
│  │   yt-dlp    │ │   ffmpeg    │                          │
│  │             │ │             │                          │
│  └─────────────┘ └─────────────┘                          │
└─────────────────────────────────────────────────────────────┘
```

## Core Components

### 1. Models Layer

#### DownloadItem.cs
- **Purpose**: Represents an active download task
- **Key Properties**:
  - `Title`: Video title
  - `FormatCode`: Selected format identifier
  - `Url`: Source video URL
  - `Progress`: Download progress (0-100)
  - `Status`: Current status (Pending, Downloading, Complete, Failed)
- **Features**: Implements `INotifyPropertyChanged` for real-time UI updates

#### HistoryItem.cs
- **Purpose**: Represents a completed download record
- **Key Properties**:
  - `Title`: Downloaded video title
  - `Format`: Downloaded format
  - `DownloadDate`: Completion timestamp
  - `FilePath`: Local file location

### 2. Services Layer

#### YtDlpService.cs
- **Purpose**: Handles all interactions with the yt-dlp command-line tool
- **Key Methods**:
  - `FetchFormatsAsync(string url)`: Retrieves available download formats
  - `DownloadAsync(string url, string formatCode, string outputPath, string? renameTitle)`: Downloads content
  - `RunProcessAsync(string fileName, string arguments)`: Generic process execution wrapper
- **Features**: Asynchronous operations, process output capture, error handling

#### FileService.cs
- **Purpose**: Manages file system operations and cross-platform compatibility
- **Key Methods**:
  - `PickFolderAsync()`: Opens folder selection dialog
  - `OpenFolder(string path)`: Opens file explorer to specified path
  - `PlayFile(string filePath)`: Opens file with default application
- **Features**: Cross-platform support (Windows, Linux, macOS)

### 3. ViewModels Layer

#### MainViewModel.cs
- **Purpose**: Main application coordinator (currently minimal)
- **Responsibilities**: Tab navigation, global state management
- **Status**: Placeholder for future enhancements

#### PasteLinkViewModel.cs
- **Purpose**: Handles URL input and format fetching
- **Key Properties**:
  - `VideoUrl`: User-entered video URL
  - `FormatsOutput`: Fetched format information
- **Commands**:
  - `FetchFormatsCommand`: Retrieves available formats for entered URL
- **Features**: Input validation, error handling, async operations

#### DownloadsViewModel.cs
- **Purpose**: Manages active download queue
- **Key Properties**:
  - `Downloads`: Observable collection of active downloads
- **Methods**:
  - `AddDownload(DownloadItem)`: Adds new download to queue
  - `RemoveDownload(DownloadItem)`: Removes completed/failed download

#### HistoryViewModel.cs
- **Purpose**: Manages download history and file operations
- **Key Properties**:
  - `HistoryItems`: Observable collection of completed downloads
- **Commands**:
  - `OpenFolderCommand`: Opens containing folder
  - `PlayFileCommand`: Plays downloaded file
  - `RemoveCommand`: Removes item from history
- **Features**: File existence validation, cross-platform file operations

### 4. Views Layer

#### MainWindow.axaml
- **Purpose**: Main application window with tabbed interface
- **Structure**: TabControl with three tabs (Paste Link, Downloads, History)
- **Features**: Modern Fluent theme, responsive layout

#### PasteLinkView.axaml
- **Purpose**: URL input and format selection interface
- **Components**: TextBox for URL input, Button for format fetching
- **Future**: Format selection UI, download options

#### DownloadsView.axaml
- **Purpose**: Active downloads monitoring interface
- **Features**: Progress bars, status indicators, download controls

#### HistoryView.axaml
- **Purpose**: Download history management interface
- **Features**: List view, action buttons (play, open folder, remove)

## Data Flow

### 1. URL Processing Flow
```
User Input (URL) → PasteLinkViewModel → YtDlpService → Format Fetching → UI Update
```

### 2. Download Flow
```
Format Selection → DownloadItem Creation → DownloadsViewModel → YtDlpService → Progress Updates → Completion → HistoryViewModel
```

### 3. File Management Flow
```
History Item Selection → HistoryViewModel → FileService → System File Operations
```

## Technology Stack

### Core Framework
- **.NET 8.0**: Modern C# runtime and libraries
- **Avalonia UI 11.3.2**: Cross-platform UI framework
- **CommunityToolkit.Mvvm 8.2.1**: MVVM helpers and commands

### UI Technologies
- **AXAML**: Avalonia's XAML variant for UI definition
- **Fluent Theme**: Modern Windows 11-style theming
- **Inter Fonts**: Modern typography

### External Dependencies
- **yt-dlp**: Video downloading engine
- **ffmpeg**: Media processing and conversion

## Design Patterns

### 1. MVVM Pattern
- **Separation of Concerns**: Clear separation between UI, business logic, and data
- **Data Binding**: Two-way binding between Views and ViewModels
- **Commands**: ICommand pattern for user actions

### 2. Observer Pattern
- **INotifyPropertyChanged**: Real-time UI updates
- **ObservableCollection**: Automatic collection change notifications

### 3. Service Pattern
- **Dependency Injection**: Services injected into ViewModels
- **Single Responsibility**: Each service handles specific functionality

### 4. Async/Await Pattern
- **Non-blocking UI**: All long-running operations are asynchronous
- **Task-based**: Modern async programming model

## Cross-Platform Considerations

### File System Operations
- **Path Handling**: Uses `Path.GetDirectoryName()` for cross-platform compatibility
- **Process Execution**: Platform-specific commands for opening files/folders
- **File Dialogs**: Avalonia's cross-platform storage provider

### UI Rendering
- **Avalonia Framework**: Native rendering on each platform
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Theme Support**: Platform-appropriate styling

## Error Handling Strategy

### Service Layer
- **Process Failures**: Captured and returned as error messages
- **Network Issues**: Handled in yt-dlp service calls
- **File System Errors**: Validation before file operations

### ViewModel Layer
- **Try-Catch Blocks**: Wrap service calls with error handling
- **User Feedback**: Error messages displayed in UI
- **Graceful Degradation**: App continues functioning after errors

### View Layer
- **Input Validation**: Client-side validation for user inputs
- **Visual Feedback**: Loading indicators and error states

## Performance Considerations

### Asynchronous Operations
- **UI Responsiveness**: All network and file operations are async
- **Background Processing**: Downloads don't block the UI thread
- **Progress Reporting**: Real-time progress updates

### Memory Management
- **Observable Collections**: Efficient collection updates
- **Process Disposal**: Proper cleanup of external processes
- **Resource Management**: Using statements for disposable resources

## Security Considerations

### Input Validation
- **URL Validation**: Basic URL format checking
- **Path Validation**: File path sanitization
- **Command Injection**: Parameterized process execution

### File System Access
- **Permission Checking**: Validate file access before operations
- **Path Traversal**: Prevent directory traversal attacks
- **Safe Downloads**: Downloads to user-selected directories only

## Future Architecture Enhancements

### Dependency Injection
- **Service Container**: Proper DI container for service management
- **Lifetime Management**: Singleton and transient service lifetimes
- **Testing Support**: Easier unit testing with DI

### Data Persistence
- **SQLite Integration**: Persistent history storage
- **Configuration Management**: User preferences and settings
- **Caching**: Format information caching

### Plugin Architecture
- **Extensibility**: Support for additional download sources
- **Modular Design**: Plugin-based feature additions
- **API Abstraction**: Common interfaces for different services

This architecture provides a solid foundation for a maintainable, extensible, and user-friendly video downloading application while following modern software development best practices.
