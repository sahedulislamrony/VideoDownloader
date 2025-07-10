using System.Collections.ObjectModel;
using System.Windows.Input;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using VideoDownloaderApp.Models;

using VideoDownloaderApp.ViewModels;

namespace VideoDownloaderApp.ViewModels
{
    public class HistoryViewModel : ViewModelBase
    {
        public ObservableCollection<HistoryItem> HistoryItems { get; } = new();

        public ICommand ClearHistoryCommand { get; }

        public HistoryViewModel()
        {
            // TODO: Load history from service or database
            // For now, add sample data
            HistoryItems.Add(new HistoryItem { Title = "Sample Video 1", Format = "MP4 720p", DownloadDate = System.DateTime.Now.AddDays(-1), FilePath = "C:\\Downloads\\video1.mp4" });
            HistoryItems.Add(new HistoryItem { Title = "Sample Video 2", Format = "MP3 Audio", DownloadDate = System.DateTime.Now.AddDays(-2), FilePath = "C:\\Downloads\\audio1.mp3" });

            ClearHistoryCommand = new RelayCommand(ClearHistory);
        }

        private void ClearHistory()
        {
            HistoryItems.Clear();
            // TODO: Also clear from persistent storage
        }
    }
}
