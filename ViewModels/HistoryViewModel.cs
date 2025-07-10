using System.Collections.ObjectModel;
using System.IO;
using System.Windows.Input;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using VideoDownloaderApp.Models;
using VideoDownloaderApp.Services;

namespace VideoDownloaderApp.ViewModels
{
    public class HistoryViewModel : ObservableObject
    {
        private readonly FileService _fileService;

        public ObservableCollection<HistoryItem> HistoryItems { get; } = new();

        public HistoryViewModel()
        {
            // Note: FileService needs a Window reference, this will be injected properly later
            _fileService = new FileService(null!);
            
            OpenFolderCommand = new RelayCommand<HistoryItem>(OpenFolder);
            PlayFileCommand = new RelayCommand<HistoryItem>(PlayFile);
            RemoveCommand = new RelayCommand<HistoryItem>(RemoveItem);
        }

        public ICommand OpenFolderCommand { get; }
        public ICommand PlayFileCommand { get; }
        public ICommand RemoveCommand { get; }

        private void OpenFolder(HistoryItem? item)
        {
            if (item != null && File.Exists(item.FilePath))
            {
                var directory = Path.GetDirectoryName(item.FilePath);
                if (directory != null)
                {
                    _fileService.OpenFolder(directory);
                }
            }
        }

        private void PlayFile(HistoryItem? item)
        {
            if (item != null && File.Exists(item.FilePath))
            {
                _fileService.PlayFile(item.FilePath);
            }
        }

        private void RemoveItem(HistoryItem? item)
        {
            if (item != null)
            {
                HistoryItems.Remove(item);
            }
        }

        public void AddHistoryItem(HistoryItem item)
        {
            HistoryItems.Insert(0, item); // Add to top of list
        }
    }
}
