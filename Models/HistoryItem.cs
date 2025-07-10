using System;

namespace VideoDownloaderApp.Models
{
    public class HistoryItem
    {
        public string Title { get; set; } = string.Empty;
        public string Format { get; set; } = string.Empty;
        public DateTime DownloadDate { get; set; }
        public string FilePath { get; set; } = string.Empty;
    }
}
