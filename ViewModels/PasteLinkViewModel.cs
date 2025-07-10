using System;
using System.Threading.Tasks;
using System.Windows.Input;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using VideoDownloaderApp.Services;

namespace VideoDownloaderApp.ViewModels
{
    public class PasteLinkViewModel : ObservableObject
    {
        private readonly YtDlpService _ytDlpService;

        public PasteLinkViewModel()
        {
            _ytDlpService = new YtDlpService();
            FetchFormatsCommand = new AsyncRelayCommand(FetchFormatsAsync);
        }

        private string _videoUrl = string.Empty;
        public string VideoUrl
        {
            get => _videoUrl;
            set => SetProperty(ref _videoUrl, value);
        }

        private string _formatsOutput = string.Empty;
        public string FormatsOutput
        {
            get => _formatsOutput;
            set => SetProperty(ref _formatsOutput, value);
        }

        public ICommand FetchFormatsCommand { get; }

        private async Task FetchFormatsAsync()
        {
            if (string.IsNullOrWhiteSpace(VideoUrl))
                return;

            FormatsOutput = "Fetching formats...";
            try
            {
                var result = await _ytDlpService.FetchFormatsAsync(VideoUrl);
                FormatsOutput = result;
            }
            catch (Exception ex)
            {
                FormatsOutput = $"Error: {ex.Message}";
            }
        }
    }
}
