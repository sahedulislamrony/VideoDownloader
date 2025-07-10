using System;
using System.IO;
using System.Threading.Tasks;
using Newtonsoft.Json;
using CommunityToolkit.Mvvm.ComponentModel;

namespace VideoDownloaderApp.Services
{
    public class AppSettings
    {
        public string YtDlpPath { get; set; } = "yt-dlp";
        public string FfmpegPath { get; set; } = "ffmpeg";
        public string DefaultDownloadPath { get; set; } = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), "Downloads");
        public bool AutoStartDownload { get; set; } = false;
        public string PreferredVideoQuality { get; set; } = "best";
        public string PreferredAudioQuality { get; set; } = "best";
        public bool ShowNotifications { get; set; } = true;
        public bool DarkTheme { get; set; } = true;
    }

    public class SettingsService : ObservableObject
    {
        private readonly string _settingsPath;
        private AppSettings _settings;

        public SettingsService()
        {
            var appDataPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "VideoDownloaderApp");
            Directory.CreateDirectory(appDataPath);
            _settingsPath = Path.Combine(appDataPath, "settings.json");
            _settings = new AppSettings();
            LoadSettings();
        }

        public AppSettings Settings
        {
            get => _settings;
            set => SetProperty(ref _settings, value);
        }

        public async Task SaveSettingsAsync()
        {
            try
            {
                var json = JsonConvert.SerializeObject(_settings, Formatting.Indented);
                await File.WriteAllTextAsync(_settingsPath, json);
            }
            catch (Exception ex)
            {
                // Log error or handle appropriately
                Console.WriteLine($"Error saving settings: {ex.Message}");
            }
        }

        private void LoadSettings()
        {
            try
            {
                if (File.Exists(_settingsPath))
                {
                    var json = File.ReadAllText(_settingsPath);
                    var loadedSettings = JsonConvert.DeserializeObject<AppSettings>(json);
                    if (loadedSettings != null)
                    {
                        _settings = loadedSettings;
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error or handle appropriately
                Console.WriteLine($"Error loading settings: {ex.Message}");
                _settings = new AppSettings(); // Use defaults
            }
        }

        public void ResetToDefaults()
        {
            _settings = new AppSettings();
            OnPropertyChanged(nameof(Settings));
        }
    }
}
