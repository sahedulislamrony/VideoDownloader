using System;
using System.Collections.Generic;
using CommunityToolkit.Mvvm.ComponentModel;

namespace VideoDownloaderApp.Models
{
    public class VideoFormat : ObservableObject
    {
        public string FormatId { get; set; } = string.Empty;
        public string Extension { get; set; } = string.Empty;
        public string Resolution { get; set; } = string.Empty;
        public string Codec { get; set; } = string.Empty;
        public string Quality { get; set; } = string.Empty;
        public string FileSize { get; set; } = string.Empty;
        public string Note { get; set; } = string.Empty;
        public bool IsAudioOnly { get; set; }
        public bool IsVideoOnly { get; set; }
        public string DisplayName => $"{Quality} - {Extension.ToUpper()} ({FileSize})";
    }

    public class VideoInfo : ObservableObject
    {
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Uploader { get; set; } = string.Empty;
        public string Duration { get; set; } = string.Empty;
        public string ViewCount { get; set; } = string.Empty;
        public string ThumbnailUrl { get; set; } = string.Empty;
        public string Url { get; set; } = string.Empty;
        public DateTime UploadDate { get; set; }
        public List<VideoFormat> VideoFormats { get; set; } = new();
        public List<VideoFormat> AudioFormats { get; set; } = new();

        private VideoFormat? _selectedVideoFormat;
        public VideoFormat? SelectedVideoFormat
        {
            get => _selectedVideoFormat;
            set => SetProperty(ref _selectedVideoFormat, value);
        }

        private VideoFormat? _selectedAudioFormat;
        public VideoFormat? SelectedAudioFormat
        {
            get => _selectedAudioFormat;
            set => SetProperty(ref _selectedAudioFormat, value);
        }

        private bool _downloadVideoOnly;
        public bool DownloadVideoOnly
        {
            get => _downloadVideoOnly;
            set => SetProperty(ref _downloadVideoOnly, value);
        }

        private bool _downloadAudioOnly;
        public bool DownloadAudioOnly
        {
            get => _downloadAudioOnly;
            set => SetProperty(ref _downloadAudioOnly, value);
        }

        private bool _downloadBoth = true;
        public bool DownloadBoth
        {
            get => _downloadBoth;
            set => SetProperty(ref _downloadBoth, value);
        }
    }

    public enum ContentType
    {
        SingleVideo,
        Playlist,
        Channel
    }
}
