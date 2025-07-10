using System;
using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace VideoDownloaderApp.Models
{
    public class DownloadItem : INotifyPropertyChanged
    {
        public string Title { get; set; } = string.Empty;
        public string FormatCode { get; set; } = string.Empty;
        public string FormatDescription { get; set; } = string.Empty;
        public string Url { get; set; } = string.Empty;
        public string SavePath { get; set; } = string.Empty;

        private double _progress;
        public double Progress
        {
            get => _progress;
            set
            {
                if (_progress != value)
                {
                    _progress = value;
                    OnPropertyChanged();
                }
            }
        }

        private string _status = "Pending";
        public string Status
        {
            get => _status;
            set
            {
                if (_status != value)
                {
                    _status = value;
                    OnPropertyChanged();
                }
            }
        }

        public event PropertyChangedEventHandler? PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string? name = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }
    }
}
