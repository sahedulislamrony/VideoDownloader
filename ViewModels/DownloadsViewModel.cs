using System.Collections.ObjectModel;
using CommunityToolkit.Mvvm.ComponentModel;
using VideoDownloaderApp.Models;

namespace VideoDownloaderApp.ViewModels
{
    public class DownloadsViewModel : ObservableObject
    {
        public ObservableCollection<DownloadItem> Downloads { get; } = new();

        public void AddDownload(DownloadItem downloadItem)
        {
            Downloads.Add(downloadItem);
        }

        public void RemoveDownload(DownloadItem downloadItem)
        {
            Downloads.Remove(downloadItem);
        }
    }
}
