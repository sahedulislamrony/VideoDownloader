# API Documentation - VideoDownloaderApp

## Overview

This document provides detailed API documentation for all services, models, and ViewModels in the VideoDownloaderApp. This documentation is intended for developers who want to understand, extend, or maintain the application.

## Table of Contents

1. [Services](#services)
   - [YtDlpService](#ytdlpservice)
   - [FileService](#fileservice)
2. [Models](#models)
   - [DownloadItem](#downloaditem)
   - [HistoryItem](#historyitem)
3. [ViewModels](#viewmodels)
   - [MainViewModel](#mainviewmodel)
   - [PasteLinkViewModel](#pastelinkviewmodel)
   - [DownloadsViewModel](#downloadsviewmodel)
   - [HistoryViewModel](#historyviewmodel)

---

## Services

### YtDlpService

**Namespace**: `VideoDownloaderApp.Services`

**Purpose**: Provides integration with the yt-dlp command-line tool for fetching video formats and downloading content.

#### Constructor

```csharp
public YtDlpService()
```

**Description**: Initializes the service with default yt-dlp path. Assumes yt-dlp is available in the system PATH.

#### Methods

##### FetchFormatsAsync

```csharp
public async Task<string> FetchFormatsAsync(string url)
```

**Description**: Retrieves available download formats for a given video URL.

**Parameters**:
- `url` (string): The video URL to analyze

**Returns**: 
- `Task<string>`: Raw output from yt-dlp containing format information

**Usage Example**:
```csharp
var ytDlpService = new YtDlpService();
var formats = await ytDlpService.FetchFormatsAsync("https://www.youtube.com/watch?v=example");
```

**Error Handling**: 
- Returns error messages in the output string if the process fails
- Network connectivity issues are reflected in the returned string

##### DownloadAsync

```csharp
public async Task<string> DownloadAsync(string url, string formatCode, string outputPath, string? renameTitle = null)
```

**Description**: Downloads video/audio content in the specified format to the given path.

**Parameters**:
- `url` (string): Source video URL
- `formatCode` (string): Format identifier (e.g., "best", "worst", "mp4", specific format codes)
- `outputPath` (string): Directory where the file should be saved
- `renameTitle` (string?, optional): Custom filename (without extension)

**Returns**: 
- `Task<string>`: Process output including download progress and completion status

**Usage Example**:
```csharp
var result = await ytDlpService.DownloadAsync(
    "https://www.youtube.com/watch?v=example",
    "best",
    "/Downloads",
    "My Custom Video Name"
);
```

**Output Template Logic**:
- With custom title: `{outputPath}/{renameTitle}.%(ext)s`
- Default: `{outputPath}/%(title)s.%(ext)s`

##### RunProcessAsync (Private)

```csharp
private async Task<string> RunProcessAsync(string fileName, string arguments)
```

**Description**: Generic method for executing command-line processes asynchronously.

**Parameters**:
- `fileName` (string): Executable name or path
- `arguments` (string): Command-line arguments

**Returns**: 
- `Task<string>`: Combined standard output and error output

**Features**:
- Captures both stdout and stderr
- Non-blocking execution
- Automatic process disposal
- Event-driven output collection

---

### FileService

**Namespace**: `VideoDownloaderApp.Services`

**Purpose**: Handles file system operations and cross-platform file management.

#### Constructor

```csharp
public FileService(Window mainWindow)
```

**Description**: Initializes the service with a reference to the main window for dialog operations.

**Parameters**:
- `mainWindow` (Window): Main application window for dialog parent

#### Methods

##### PickFolderAsync

```csharp
public async Task<string?> PickFolderAsync()
```

**Description**: Opens a folder selection dialog for the user to choose a download location.

**Returns**: 
- `Task<string?>`: Selected folder path, or null if cancelled

**Usage Example**:
```csharp
var fileService = new FileService(mainWindow);
var selectedPath = await fileService.PickFolderAsync();
if (selectedPath != null)
{
    // Use the selected path
}
```

**Dialog Configuration**:
- Title: "Select Save Location"
- Type: Folder picker
- Multi-selection: Disabled

##### OpenFolder

```csharp
public void OpenFolder(string path)
```

**Description**: Opens the system file explorer to the specified directory.

**Parameters**:
- `path` (string): Directory path to open

**Platform Behavior**:
- **Windows**: Uses `explorer.exe` with the path
- **Linux**: Uses `xdg-open` command
- **macOS**: Uses `open` command

**Usage Example**:
```csharp
fileService.OpenFolder("/path/to/downloads");
```

**Error Handling**: 
- No explicit error handling; relies on OS command success
- Invalid paths may result in no action or system error dialogs

##### PlayFile

```csharp
public void PlayFile(string filePath)
```

**Description**: Opens a file with the system's default application.

**Parameters**:
- `filePath` (string): Full path to the file to open

**Platform Behavior**:
- **Windows**: Uses `cmd /c start` command
- **Linux**: Uses `xdg-open` command
- **macOS**: Uses `open` command

**Usage Example**:
```csharp
fileService.PlayFile("/path/to/video.mp4");
```

---

## Models

### DownloadItem

**Namespace**: `VideoDownloaderApp.Models`

**Purpose**: Represents an active download task with progress tracking capabilities.

**Inheritance**: Implements `INotifyPropertyChanged`

#### Properties

##### Title
```csharp
public string Title { get; set; } = string.Empty;
```
**Description**: Display name of the video being downloaded.

##### FormatCode
```csharp
public string FormatCode { get; set; } = string.Empty;
```
**Description**: yt-dlp format identifier for the selected quality/format.

##### FormatDescription
```csharp
public string FormatDescription { get; set; } = string.Empty;
```
**Description**: Human-readable description of the selected format.

##### Url
```csharp
public string Url { get; set; } = string.Empty;
```
**Description**: Source URL of the video.

##### SavePath
```csharp
public string SavePath { get; set; } = string.Empty;
```
**Description**: Local directory where the file will be saved.

##### Progress
```csharp
public double Progress { get; set; }
```
**Description**: Download progress percentage (0.0 to 100.0).
**Features**: Raises PropertyChanged event for UI binding.

##### Status
```csharp
public string Status { get; set; } = "Pending";
```
**Description**: Current download status.
**Possible Values**: "Pending", "Downloading", "Complete", "Failed"
**Features**: Raises PropertyChanged event for UI binding.

#### Usage Example

```csharp
var downloadItem = new DownloadItem
{
    Title = "Example Video",
    FormatCode = "best",
    FormatDescription = "Best quality available",
    Url = "https://example.com/video",
    SavePath = "/Downloads",
    Progress = 0.0,
    Status = "Pending"
};

// Progress updates will automatically notify the UI
downloadItem.Progress = 50.0;
downloadItem.Status = "Downloading";
```

---

### HistoryItem

**Namespace**: `VideoDownloaderApp.Models`

**Purpose**: Represents a completed download record for history tracking.

#### Properties

##### Title
```csharp
public string Title { get; set; } = string.Empty;
```
**Description**: Name of the downloaded video.

##### Format
```csharp
public string Format { get; set; } = string.Empty;
```
**Description**: Format that was downloaded (e.g., "mp4", "mp3").

##### DownloadDate
```csharp
public DateTime DownloadDate { get; set; }
```
**Description**: Timestamp when the download was completed.

##### FilePath
```csharp
public string FilePath { get; set; } = string.Empty;
```
**Description**: Full path to the downloaded file on the local system.

#### Usage Example

```csharp
var historyItem = new HistoryItem
{
    Title = "Example Video",
    Format = "mp4",
    DownloadDate = DateTime.Now,
    FilePath = "/Downloads/Example Video.mp4"
};
```

---

## ViewModels

### MainViewModel

**Namespace**: `VideoDownloaderApp.ViewModels`

**Purpose**: Main application coordinator and tab navigation controller.

**Inheritance**: Inherits from `ObservableObject`

#### Current Status
This ViewModel is currently minimal and serves as a placeholder for future enhancements.

#### Planned Features
- Tab navigation state management
- Global application settings
- Cross-tab communication
- User authentication (if required)

#### Usage Example
```csharp
var mainViewModel = new MainViewModel();
// Currently no specific functionality implemented
```

---

### PasteLinkViewModel

**Namespace**: `VideoDownloaderApp.ViewModels`

**Purpose**: Handles URL input, format fetching, and download initiation.

**Inheritance**: Inherits from `ObservableObject`

#### Properties

##### VideoUrl
```csharp
public string VideoUrl { get; set; }
```
**Description**: User-entered video URL.
**Features**: Two-way data binding with UI TextBox.

##### FormatsOutput
```csharp
public string FormatsOutput { get; set; }
```
**Description**: Raw format information returned from yt-dlp.
**Features**: Updates UI display of available formats.

#### Commands

##### FetchFormatsCommand
```csharp
public ICommand FetchFormatsCommand { get; }
```
**Description**: Asynchronous command to retrieve available formats for the entered URL.

**Implementation**: `AsyncRelayCommand` that calls `FetchFormatsAsync()`

**Behavior**:
1. Validates that VideoUrl is not empty
2. Sets FormatsOutput to "Fetching formats..."
3. Calls YtDlpService.FetchFormatsAsync()
4. Updates FormatsOutput with results or error message

#### Methods

##### FetchFormatsAsync (Private)
```csharp
private async Task FetchFormatsAsync()
```
**Description**: Executes the format fetching operation.

**Error Handling**: 
- Catches exceptions and displays error messages
- Updates UI with "Error: {exception message}" format

#### Usage Example

```csharp
var viewModel = new PasteLinkViewModel();
viewModel.VideoUrl = "https://www.youtube.com/watch?v=example";

// Execute command (typically bound to UI button)
if (viewModel.FetchFormatsCommand.CanExecute(null))
{
    viewModel.FetchFormatsCommand.Execute(null);
}
```

---

### DownloadsViewModel

**Namespace**: `VideoDownloaderApp.ViewModels`

**Purpose**: Manages the queue of active downloads and their progress.

**Inheritance**: Inherits from `ObservableObject`

#### Properties

##### Downloads
```csharp
public ObservableCollection<DownloadItem> Downloads { get; }
```
**Description**: Collection of active download tasks.
**Features**: Automatically notifies UI of collection changes.

#### Methods

##### AddDownload
```csharp
public void AddDownload(DownloadItem downloadItem)
```
**Description**: Adds a new download to the active queue.

**Parameters**:
- `downloadItem` (DownloadItem): The download task to add

**Usage Example**:
```csharp
var downloadsViewModel = new DownloadsViewModel();
var newDownload = new DownloadItem
{
    Title = "Video Title",
    Url = "https://example.com/video",
    Status = "Pending"
};
downloadsViewModel.AddDownload(newDownload);
```

##### RemoveDownload
```csharp
public void RemoveDownload(DownloadItem downloadItem)
```
**Description**: Removes a download from the active queue.

**Parameters**:
- `downloadItem` (DownloadItem): The download task to remove

**Usage Example**:
```csharp
downloadsViewModel.RemoveDownload(completedDownload);
```

---

### HistoryViewModel

**Namespace**: `VideoDownloaderApp.ViewModels`

**Purpose**: Manages download history and provides file operation commands.

**Inheritance**: Inherits from `ObservableObject`

#### Properties

##### HistoryItems
```csharp
public ObservableCollection<HistoryItem> HistoryItems { get; }
```
**Description**: Collection of completed downloads.
**Features**: Automatically notifies UI of collection changes.

#### Commands

##### OpenFolderCommand
```csharp
public ICommand OpenFolderCommand { get; }
```
**Description**: Opens the containing folder of a history item.
**Implementation**: `RelayCommand<HistoryItem>`

##### PlayFileCommand
```csharp
public ICommand PlayFileCommand { get; }
```
**Description**: Opens a downloaded file with the default application.
**Implementation**: `RelayCommand<HistoryItem>`

##### RemoveCommand
```csharp
public ICommand RemoveCommand { get; }
```
**Description**: Removes an item from the download history.
**Implementation**: `RelayCommand<HistoryItem>`

#### Methods

##### OpenFolder (Private)
```csharp
private void OpenFolder(HistoryItem? item)
```
**Description**: Executes folder opening operation.

**Validation**:
- Checks if item is not null
- Verifies file exists using `File.Exists()`
- Extracts directory path using `Path.GetDirectoryName()`

##### PlayFile (Private)
```csharp
private void PlayFile(HistoryItem? item)
```
**Description**: Executes file opening operation.

**Validation**:
- Checks if item is not null
- Verifies file exists using `File.Exists()`

##### RemoveItem (Private)
```csharp
private void RemoveItem(HistoryItem? item)
```
**Description**: Removes item from history collection.

##### AddHistoryItem
```csharp
public void AddHistoryItem(HistoryItem item)
```
**Description**: Adds a new item to the history (at the top of the list).

**Parameters**:
- `item` (HistoryItem): The completed download to add to history

#### Usage Example

```csharp
var historyViewModel = new HistoryViewModel();

// Add completed download to history
var historyItem = new HistoryItem
{
    Title = "Downloaded Video",
    Format = "mp4",
    DownloadDate = DateTime.Now,
    FilePath = "/Downloads/video.mp4"
};
historyViewModel.AddHistoryItem(historyItem);

// Commands are typically bound to UI buttons
// historyViewModel.PlayFileCommand.Execute(historyItem);
```

#### Known Issues

**FileService Dependency**: The constructor currently passes `null!` for the Window reference to FileService. This should be resolved through proper dependency injection in future versions.

---

## Error Handling Patterns

### Service Layer Errors
- **YtDlpService**: Returns error messages as strings in the output
- **FileService**: Relies on OS-level error handling

### ViewModel Layer Errors
- **Try-Catch Blocks**: Wrap service calls with exception handling
- **User Feedback**: Display error messages in UI-bound properties
- **Graceful Degradation**: Continue operation after non-critical errors

### Recommended Error Handling Improvements
1. Implement structured logging
2. Add specific exception types
3. Provide user-friendly error messages
4. Add retry mechanisms for network operations

---

## Threading and Async Patterns

### Async/Await Usage
- All long-running operations use async/await pattern
- UI thread remains responsive during operations
- Proper task completion handling

### Observable Collections
- Thread-safe collection updates
- Automatic UI synchronization
- Property change notifications

### Command Execution
- AsyncRelayCommand for async operations
- RelayCommand for synchronous operations
- Automatic CanExecute handling

This API documentation provides a comprehensive reference for developers working with the VideoDownloaderApp codebase. For architectural overview and design patterns, refer to the Architecture.md document.
