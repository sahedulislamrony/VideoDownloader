using System.Threading.Tasks;
using System.Windows.Input;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using VideoDownloaderApp.Services;

using VideoDownloaderApp.ViewModels;

namespace VideoDownloaderApp.ViewModels
{
    public class SettingsViewModel : ViewModelBase
    {
        private readonly SettingsService _settingsService;

        public SettingsViewModel()
        {
            _settingsService = new SettingsService();

            YtDlpPath = _settingsService.Settings.YtDlpPath;
            FfmpegPath = _settingsService.Settings.FfmpegPath;
            DefaultDownloadPath = _settingsService.Settings.DefaultDownloadPath;

            SaveSettingsCommand = new AsyncRelayCommand(SaveSettingsAsync);
        }

        private string _ytDlpPath = string.Empty;
        public string YtDlpPath
        {
            get => _ytDlpPath;
            set => SetProperty(ref _ytDlpPath, value);
        }

        private string _ffmpegPath = string.Empty;
        public string FfmpegPath
        {
            get => _ffmpegPath;
            set => SetProperty(ref _ffmpegPath, value);
        }

        private string _defaultDownloadPath = string.Empty;
        public string DefaultDownloadPath
        {
            get => _defaultDownloadPath;
            set => SetProperty(ref _defaultDownloadPath, value);
        }

        public ICommand SaveSettingsCommand { get; }

        private async Task SaveSettingsAsync()
        {
            _settingsService.Settings.YtDlpPath = YtDlpPath;
            _settingsService.Settings.FfmpegPath = FfmpegPath;
            _settingsService.Settings.DefaultDownloadPath = DefaultDownloadPath;

            await _settingsService.SaveSettingsAsync();
        }
    }
}
