using System;
using System.Threading.Tasks;
using System.Windows.Input;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using VideoDownloaderApp.Models;
using VideoDownloaderApp.Services;

using VideoDownloaderApp.ViewModels;

namespace VideoDownloaderApp.ViewModels
{
    public class HomeViewModel : ViewModelBase
    {
        private readonly YtDlpService _ytDlpService;

        public HomeViewModel()
        {
            _ytDlpService = new YtDlpService();

            FetchVideoInfoCommand = new AsyncRelayCommand(FetchVideoInfoAsync);
            DownloadVideoCommand = new AsyncRelayCommand(DownloadVideoAsync);
            DownloadAudioCommand = new AsyncRelayCommand(DownloadAudioAsync);

            IsSingleVideo = true;
        }

        private string _videoUrl = string.Empty;
        public string VideoUrl
        {
            get => _videoUrl;
            set => SetProperty(ref _videoUrl, value);
        }

        private bool _isSingleVideo;
        public bool IsSingleVideo
        {
            get => _isSingleVideo;
            set => SetProperty(ref _isSingleVideo, value);
        }

        private bool _isPlaylist;
        public bool IsPlaylist
        {
            get => _isPlaylist;
            set => SetProperty(ref _isPlaylist, value);
        }

        private bool _isChannel;
        public bool IsChannel
        {
            get => _isChannel;
            set => SetProperty(ref _isChannel, value);
        }

        private VideoInfo? _videoInfo;
        public VideoInfo? VideoInfo
        {
            get => _videoInfo;
            set => SetProperty(ref _videoInfo, value);
        }

        private bool _isVideoInfoVisible;
        public bool IsVideoInfoVisible
        {
            get => _isVideoInfoVisible;
            set => SetProperty(ref _isVideoInfoVisible, value);
        }

        public ICommand FetchVideoInfoCommand { get; }
        public ICommand DownloadVideoCommand { get; }
        public ICommand DownloadAudioCommand { get; }

        private async Task FetchVideoInfoAsync()
        {
            if (string.IsNullOrWhiteSpace(VideoUrl))
                return;

            try
            {
                // TODO: Fetch video info using YtDlpService and parse into VideoInfo model
                // For now, simulate with dummy data
                await Task.Delay(1000);

                VideoInfo = new VideoInfo
                {
                    Title = "Sample Video Title",
                    Description = "This is a sample video description.",
                    ThumbnailUrl = "https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg",
                    Duration = "00:03:33",
                    Uploader = "Sample Uploader"
                };

                IsVideoInfoVisible = true;
            }
            catch (Exception)
            {
                // Handle error (show message, log, etc.)
                IsVideoInfoVisible = false;
            }
        }

        private async Task DownloadVideoAsync()
        {
            if (VideoInfo == null)
                return;

            // TODO: Implement video download logic using YtDlpService
            await Task.Delay(500);
        }

        private async Task DownloadAudioAsync()
        {
            if (VideoInfo == null)
                return;

            // TODO: Implement audio download logic using YtDlpService
            await Task.Delay(500);
        }
    }
}
