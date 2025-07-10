using System.Collections.ObjectModel;
using VideoDownloaderApp.Models;
using CommunityToolkit.Mvvm.ComponentModel;

using VideoDownloaderApp.ViewModels;

namespace VideoDownloaderApp.ViewModels
{
    public class DownloadsViewModel : ViewModelBase
    {
        public ObservableCollection<DownloadItem> PendingDownloads { get; } = new();
        public ObservableCollection<DownloadItem> InProgressDownloads { get; } = new();
        public ObservableCollection<DownloadItem> CompletedDownloads { get; } = new();

        public DownloadsViewModel()
        {
            // TODO: Load downloads from service or database
            // For now, add sample data
            PendingDownloads.Add(new DownloadItem { Title = "Sample Pending Video", FormatDescription = "MP4 720p", Status = "Pending", Progress = 0 });
            InProgressDownloads.Add(new DownloadItem { Title = "Sample Downloading Video", FormatDescription = "MP4 1080p", Status = "Downloading", Progress = 45 });
            CompletedDownloads.Add(new DownloadItem { Title = "Sample Completed Video", FormatDescription = "MP4 480p", Status = "Completed", Progress = 100 });
        }
    }
}
