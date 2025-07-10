# Developer Guide - VideoDownloaderApp

## Table of Contents

1. [Development Environment Setup](#development-environment-setup)
2. [Project Structure Deep Dive](#project-structure-deep-dive)
3. [MVVM Implementation](#mvvm-implementation)
4. [Service Layer Design](#service-layer-design)
5. [UI Development with Avalonia](#ui-development-with-avalonia)
6. [Error Handling Patterns](#error-handling-patterns)
7. [Testing Guidelines](#testing-guidelines)
8. [Performance Optimization](#performance-optimization)
9. [Cross-Platform Considerations](#cross-platform-considerations)
10. [Debugging and Troubleshooting](#debugging-and-troubleshooting)
11. [Code Style and Conventions](#code-style-and-conventions)
12. [Contributing Workflow](#contributing-workflow)

---

## Development Environment Setup

### Prerequisites

**Required Software:**
- [Visual Studio 2022](https://visualstudio.microsoft.com/) or [JetBrains Rider](https://www.jetbrains.com/rider/)
- [.NET 8.0 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [Git](https://git-scm.com/)

**Optional but Recommended:**
- [Visual Studio Code](https://code.visualstudio.com/) with C# extension
- [Avalonia for Visual Studio](https://marketplace.visualstudio.com/items?itemName=AvaloniaTeam.AvaloniaVS) extension
- [yt-dlp](https://github.com/yt-dlp/yt-dlp) for testing
- [ffmpeg](https://ffmpeg.org/) for media processing

### IDE Configuration

#### Visual Studio 2022
```xml
<!-- Add to .editorconfig -->
root = true

[*.cs]
indent_style = space
indent_size = 4
end_of_line = crlf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

# C# formatting rules
csharp_new_line_before_open_brace = all
csharp_new_line_before_else = true
csharp_new_line_before_catch = true
csharp_new_line_before_finally = true
```

#### Rider Configuration
- Enable "Code Inspection" for C# and XAML
- Configure "File Watchers" for automatic formatting
- Set up "Live Templates" for common MVVM patterns

### Project Setup

```bash
# Clone the repository
git clone [repository-url]
cd VideoDownloaderApp

# Restore NuGet packages
dotnet restore

# Build the solution
dotnet build

# Run the application
dotnet run --project VideoDownloaderApp
```

---

## Project Structure Deep Dive

### Directory Organization

```
VideoDownloaderApp/
├── 📁 Models/                  # Data models and entities
├── 📁 ViewModels/              # MVVM view models
├── 📁 Views/                   # UI views (AXAML + code-behind)
├── 📁 Services/                # Business logic and external integrations
├── 📁 Resources/               # Static resources (images, fonts)
├── 📁 Assets/                  # Application assets
├── 📁 docs/                    # Documentation
└── 📁 Tests/                   # Unit and integration tests (future)
```

### File Naming Conventions

- **Models**: `{EntityName}.cs` (e.g., `DownloadItem.cs`)
- **ViewModels**: `{ViewName}ViewModel.cs` (e.g., `PasteLinkViewModel.cs`)
- **Views**: `{ViewName}.axaml` and `{ViewName}.axaml.cs`
- **Services**: `{ServiceName}Service.cs` (e.g., `YtDlpService.cs`)
- **Interfaces**: `I{InterfaceName}.cs` (e.g., `IDownloadService.cs`)

### Dependency Flow

```
Views → ViewModels → Services → External APIs/CLI Tools
  ↓         ↓           ↓
Models ← Models ← Models
```

---

## MVVM Implementation

### ViewModelBase Pattern

```csharp
using CommunityToolkit.Mvvm.ComponentModel;

public abstract class ViewModelBase : ObservableObject
{
    private bool _isBusy;
    public bool IsBusy
    {
        get => _isBusy;
        set => SetProperty(ref _isBusy, value);
    }

    private string _errorMessage = string.Empty;
    public string ErrorMessage
    {
        get => _errorMessage;
        set => SetProperty(ref _errorMessage, value);
    }

    protected virtual void OnError(Exception exception)
    {
        ErrorMessage = exception.Message;
        // Log exception
    }
}
```

### Command Implementation

```csharp
using CommunityToolkit.Mvvm.Input;

public partial class ExampleViewModel : ViewModelBase
{
    [RelayCommand]
    private async Task ExecuteActionAsync()
    {
        try
        {
            IsBusy = true;
            ErrorMessage = string.Empty;
            
            // Perform action
            await SomeAsyncOperation();
        }
        catch (Exception ex)
        {
            OnError(ex);
        }
        finally
        {
            IsBusy = false;
        }
    }

    [RelayCommand(CanExecute = nameof(CanExecuteAction))]
    private void ExecuteAction(object? parameter)
    {
        // Synchronous action
    }

    private bool CanExecuteAction() => !IsBusy;
}
```

### Property Binding Best Practices

```csharp
// ✅ Good: Use SetProperty for automatic change notification
private string _title = string.Empty;
public string Title
{
    get => _title;
    set => SetProperty(ref _title, value);
}

// ✅ Good: Computed properties with OnPropertyChanged
public string DisplayTitle => $"{Title} - {Status}";

private void OnTitleChanged()
{
    OnPropertyChanged(nameof(DisplayTitle));
}

// ❌ Bad: Manual property implementation
private string _badTitle;
public string BadTitle
{
    get => _badTitle;
    set
    {
        _badTitle = value;
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(BadTitle)));
    }
}
```

---

## Service Layer Design

### Service Interface Pattern

```csharp
public interface IYtDlpService
{
    Task<string> FetchFormatsAsync(string url, CancellationToken cancellationToken = default);
    Task<DownloadResult> DownloadAsync(DownloadRequest request, IProgress<DownloadProgress>? progress = null, CancellationToken cancellationToken = default);
}

public class YtDlpService : IYtDlpService
{
    private readonly ILogger<YtDlpService> _logger;
    
    public YtDlpService(ILogger<YtDlpService> logger)
    {
        _logger = logger;
    }
    
    // Implementation...
}
```

### Dependency Injection Setup

```csharp
// Program.cs or App.axaml.cs
public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddApplicationServices(this IServiceCollection services)
    {
        services.AddSingleton<IYtDlpService, YtDlpService>();
        services.AddSingleton<IFileService, FileService>();
        services.AddTransient<PasteLinkViewModel>();
        services.AddTransient<DownloadsViewModel>();
        services.AddTransient<HistoryViewModel>();
        
        return services;
    }
}
```

### Error Handling in Services

```csharp
public async Task<Result<string>> FetchFormatsAsync(string url)
{
    try
    {
        _logger.LogInformation("Fetching formats for URL: {Url}", url);
        
        var result = await RunProcessAsync("yt-dlp", $"-F \"{url}\"");
        
        _logger.LogInformation("Successfully fetched formats for URL: {Url}", url);
        return Result.Success(result);
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Failed to fetch formats for URL: {Url}", url);
        return Result.Failure<string>($"Failed to fetch formats: {ex.Message}");
    }
}
```

---

## UI Development with Avalonia

### AXAML Best Practices

```xml
<!-- ✅ Good: Proper data binding and styling -->
<UserControl xmlns="https://github.com/avaloniaui"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             xmlns:vm="clr-namespace:VideoDownloaderApp.ViewModels"
             x:Class="VideoDownloaderApp.Views.ExampleView"
             x:DataType="vm:ExampleViewModel">

    <Design.DataContext>
        <vm:ExampleViewModel />
    </Design.DataContext>

    <Grid RowDefinitions="Auto,*,Auto" Margin="16">
        <TextBox Grid.Row="0"
                 Text="{Binding InputText}"
                 Watermark="Enter text here..."
                 Classes="modern-textbox" />
        
        <ListBox Grid.Row="1"
                 ItemsSource="{Binding Items}"
                 SelectedItem="{Binding SelectedItem}"
                 Margin="0,8">
            <ListBox.ItemTemplate>
                <DataTemplate>
                    <TextBlock Text="{Binding DisplayName}" />
                </DataTemplate>
            </ListBox.ItemTemplate>
        </ListBox>
        
        <Button Grid.Row="2"
                Content="Execute"
                Command="{Binding ExecuteCommand}"
                IsEnabled="{Binding !IsBusy}"
                Classes="primary-button" />
    </Grid>
</UserControl>
```

### Custom Styles and Themes

```xml
<!-- Styles/Controls.axaml -->
<Styles xmlns="https://github.com/avaloniaui"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    
    <Style Selector="Button.primary-button">
        <Setter Property="Background" Value="#007ACC" />
        <Setter Property="Foreground" Value="White" />
        <Setter Property="Padding" Value="16,8" />
        <Setter Property="CornerRadius" Value="4" />
        <Setter Property="FontWeight" Value="SemiBold" />
    </Style>
    
    <Style Selector="Button.primary-button:pointerover">
        <Setter Property="Background" Value="#005A9E" />
    </Style>
    
    <Style Selector="TextBox.modern-textbox">
        <Setter Property="BorderBrush" Value="#E0E0E0" />
        <Setter Property="BorderThickness" Value="1" />
        <Setter Property="CornerRadius" Value="4" />
        <Setter Property="Padding" Value="12,8" />
    </Style>
</Styles>
```

### Data Templates and Converters

```csharp
// Converters/BoolToVisibilityConverter.cs
public class BoolToVisibilityConverter : IValueConverter
{
    public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
    {
        if (value is bool boolValue)
        {
            return boolValue ? Avalonia.Layout.Visibility.Visible : Avalonia.Layout.Visibility.Collapsed;
        }
        return Avalonia.Layout.Visibility.Collapsed;
    }

    public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
    {
        throw new NotImplementedException();
    }
}
```

---

## Error Handling Patterns

### Result Pattern Implementation

```csharp
public class Result<T>
{
    public bool IsSuccess { get; }
    public T? Value { get; }
    public string? Error { get; }

    private Result(bool isSuccess, T? value, string? error)
    {
        IsSuccess = isSuccess;
        Value = value;
        Error = error;
    }

    public static Result<T> Success(T value) => new(true, value, null);
    public static Result<T> Failure(string error) => new(false, default, error);
}

// Usage in ViewModels
public async Task LoadDataAsync()
{
    var result = await _service.GetDataAsync();
    if (result.IsSuccess)
    {
        Data = result.Value;
    }
    else
    {
        ErrorMessage = result.Error;
    }
}
```

### Global Exception Handling

```csharp
// App.axaml.cs
public partial class App : Application
{
    public override void Initialize()
    {
        AvaloniaXamlLoader.Load(this);
        
        // Global exception handling
        AppDomain.CurrentDomain.UnhandledException += OnUnhandledException;
        TaskScheduler.UnobservedTaskException += OnUnobservedTaskException;
    }

    private void OnUnhandledException(object sender, UnhandledExceptionEventArgs e)
    {
        LogException(e.ExceptionObject as Exception);
        // Show user-friendly error dialog
    }

    private void OnUnobservedTaskException(object? sender, UnobservedTaskExceptionEventArgs e)
    {
        LogException(e.Exception);
        e.SetObserved();
    }
}
```

---

## Testing Guidelines

### Unit Testing Setup

```csharp
// Tests/ViewModels/PasteLinkViewModelTests.cs
[TestClass]
public class PasteLinkViewModelTests
{
    private Mock<IYtDlpService> _mockYtDlpService;
    private PasteLinkViewModel _viewModel;

    [TestInitialize]
    public void Setup()
    {
        _mockYtDlpService = new Mock<IYtDlpService>();
        _viewModel = new PasteLinkViewModel(_mockYtDlpService.Object);
    }

    [TestMethod]
    public async Task FetchFormatsAsync_ValidUrl_UpdatesFormatsOutput()
    {
        // Arrange
        const string testUrl = "https://www.youtube.com/watch?v=test";
        const string expectedOutput = "format list";
        _mockYtDlpService.Setup(x => x.FetchFormatsAsync(testUrl))
                        .ReturnsAsync(Result.Success(expectedOutput));

        _viewModel.VideoUrl = testUrl;

        // Act
        await _viewModel.FetchFormatsCommand.ExecuteAsync(null);

        // Assert
        Assert.AreEqual(expectedOutput, _viewModel.FormatsOutput);
        Assert.IsFalse(_viewModel.IsBusy);
    }
}
```

### Integration Testing

```csharp
[TestClass]
public class YtDlpServiceIntegrationTests
{
    private YtDlpService _service;

    [TestInitialize]
    public void Setup()
    {
        _service = new YtDlpService();
    }

    [TestMethod]
    [TestCategory("Integration")]
    public async Task FetchFormatsAsync_YouTubeUrl_ReturnsFormats()
    {
        // This test requires yt-dlp to be installed
        const string testUrl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
        
        var result = await _service.FetchFormatsAsync(testUrl);
        
        Assert.IsTrue(result.IsSuccess);
        Assert.IsTrue(result.Value.Contains("format"));
    }
}
```

---

## Performance Optimization

### Async/Await Best Practices

```csharp
// ✅ Good: Proper async implementation
public async Task<string> ProcessDataAsync()
{
    var data = await FetchDataAsync().ConfigureAwait(false);
    var processed = await ProcessAsync(data).ConfigureAwait(false);
    return processed;
}

// ✅ Good: Parallel processing when appropriate
public async Task<IEnumerable<Result>> ProcessMultipleAsync(IEnumerable<string> urls)
{
    var tasks = urls.Select(ProcessSingleAsync);
    return await Task.WhenAll(tasks);
}

// ❌ Bad: Blocking async calls
public string ProcessDataSync()
{
    return ProcessDataAsync().Result; // Don't do this!
}
```

### Memory Management

```csharp
// ✅ Good: Proper disposal
public async Task DownloadFileAsync(string url, string path)
{
    using var httpClient = new HttpClient();
    using var response = await httpClient.GetAsync(url);
    using var fileStream = File.Create(path);
    await response.Content.CopyToAsync(fileStream);
}

// ✅ Good: Weak event handlers to prevent memory leaks
public class ViewModel : INotifyPropertyChanged
{
    public event PropertyChangedEventHandler? PropertyChanged;
    
    protected virtual void OnPropertyChanged([CallerMemberName] string? propertyName = null)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}
```

### UI Performance

```csharp
// ✅ Good: Virtualization for large lists
<ListBox ItemsSource="{Binding LargeCollection}"
         VirtualizationMode="Recycling"
         ScrollViewer.HorizontalScrollBarVisibility="Disabled">
    <ListBox.ItemsPanel>
        <ItemsPanelTemplate>
            <VirtualizingStackPanel />
        </ItemsPanelTemplate>
    </ListBox.ItemsPanel>
</ListBox>

// ✅ Good: Debounced search
private readonly Timer _searchTimer = new(500);

public string SearchText
{
    get => _searchText;
    set
    {
        SetProperty(ref _searchText, value);
        _searchTimer.Stop();
        _searchTimer.Start();
        _searchTimer.Elapsed += (s, e) => PerformSearch();
    }
}
```

---

## Cross-Platform Considerations

### Platform-Specific Code

```csharp
public static class PlatformHelper
{
    public static bool IsWindows => RuntimeInformation.IsOSPlatform(OSPlatform.Windows);
    public static bool IsLinux => RuntimeInformation.IsOSPlatform(OSPlatform.Linux);
    public static bool IsMacOS => RuntimeInformation.IsOSPlatform(OSPlatform.OSX);

    public static string GetDefaultDownloadPath()
    {
        if (IsWindows)
            return Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), "Downloads");
        else
            return Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Personal), "Downloads");
    }
}
```

### File Path Handling

```csharp
// ✅ Good: Cross-platform path handling
public static string CombinePaths(params string[] paths)
{
    return Path.Combine(paths);
}

public static string NormalizePath(string path)
{
    return Path.GetFullPath(path);
}

// ❌ Bad: Platform-specific separators
public static string BadCombinePaths(string path1, string path2)
{
    return path1 + "\\" + path2; // Only works on Windows
}
```

---

## Debugging and Troubleshooting

### Logging Configuration

```csharp
// Program.cs
public static void Main(string[] args)
{
    var loggerFactory = LoggerFactory.Create(builder =>
    {
        builder.AddConsole()
               .AddDebug()
               .SetMinimumLevel(LogLevel.Information);
    });

    var logger = loggerFactory.CreateLogger<Program>();
    logger.LogInformation("Application starting...");

    BuildAvaloniaApp().StartWithClassicDesktopLifetime(args);
}
```

### Debug Helpers

```csharp
public static class DebugHelper
{
    [Conditional("DEBUG")]
    public static void LogViewModelState(object viewModel)
    {
        var properties = viewModel.GetType().GetProperties();
        foreach (var prop in properties)
        {
            var value = prop.GetValue(viewModel);
            Debug.WriteLine($"{prop.Name}: {value}");
        }
    }
}
```

### Common Issues and Solutions

**Issue: Data binding not working**
```xml
<!-- Solution: Ensure proper DataContext and x:DataType -->
<UserControl x:DataType="vm:MyViewModel">
    <TextBlock Text="{Binding MyProperty}" />
</UserControl>
```

**Issue: Commands not executing**
```csharp
// Solution: Check CanExecute logic
[RelayCommand(CanExecute = nameof(CanExecuteMyCommand))]
private void ExecuteMyCommand() { }

private bool CanExecuteMyCommand() => !IsBusy && IsValid;
```

---

## Code Style and Conventions

### C# Coding Standards

```csharp
// ✅ Good: Proper naming and structure
public class VideoDownloadService : IVideoDownloadService
{
    private readonly ILogger<VideoDownloadService> _logger;
    private readonly HttpClient _httpClient;

    public VideoDownloadService(ILogger<VideoDownloadService> logger, HttpClient httpClient)
    {
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        _httpClient = httpClient ?? throw new ArgumentNullException(nameof(httpClient));
    }

    public async Task<DownloadResult> DownloadAsync(DownloadRequest request, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(request);
        
        try
        {
            _logger.LogInformation("Starting download for {Url}", request.Url);
            
            // Implementation...
            
            return new DownloadResult { Success = true };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Download failed for {Url}", request.Url);
            throw;
        }
    }
}
```

### XML Documentation

```csharp
/// <summary>
/// Provides functionality for downloading videos from various platforms.
/// </summary>
/// <remarks>
/// This service integrates with yt-dlp to support downloading from 1000+ websites.
/// All operations are asynchronous and support cancellation.
/// </remarks>
public class VideoDownloadService
{
    /// <summary>
    /// Downloads a video from the specified URL.
    /// </summary>
    /// <param name="request">The download request containing URL and options.</param>
    /// <param name="cancellationToken">Token to cancel the operation.</param>
    /// <returns>A task representing the download operation result.</returns>
    /// <exception cref="ArgumentNullException">Thrown when request is null.</exception>
    /// <exception cref="InvalidOperationException">Thrown when yt-dlp is not available.</exception>
    public async Task<DownloadResult> DownloadAsync(DownloadRequest request, CancellationToken cancellationToken = default)
    {
        // Implementation...
    }
}
```

---

## Contributing Workflow

### Git Workflow

```bash
# 1. Create feature branch
git checkout -b feature/new-download-feature

# 2. Make changes and commit
git add .
git commit -m "feat: add batch download functionality"

# 3. Push and create PR
git push origin feature/new-download-feature
```

### Commit Message Convention

```
type(scope): description

feat(downloads): add batch download functionality
fix(ui): resolve progress bar display issue
docs(api): update service documentation
test(viewmodels): add unit tests for PasteLinkViewModel
refactor(services): improve error handling
```

### Code Review Checklist

- [ ] Code follows project conventions
- [ ] All tests pass
- [ ] Documentation is updated
- [ ] No breaking changes (or properly documented)
- [ ] Cross-platform compatibility verified
- [ ] Performance impact considered
- [ ] Security implications reviewed

### Release Process

1. **Version Bump**: Update version in `.csproj` file
2. **Changelog**: Update `CHANGELOG.md` with new features and fixes
3. **Testing**: Run full test suite on all platforms
4. **Documentation**: Update documentation if needed
5. **Release**: Create GitHub release with binaries

---

This developer guide provides comprehensive information for contributing to and maintaining the VideoDownloaderApp project. For specific API details, refer to the [API Documentation](API_Documentation.md), and for architectural insights, see the [Architecture Guide](Architecture.md).
