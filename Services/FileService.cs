using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using Avalonia.Controls;
using Avalonia.Platform.Storage;

namespace VideoDownloaderApp.Services
{
    public class FileService
    {
        private readonly Window _mainWindow;

        public FileService(Window mainWindow)
        {
            _mainWindow = mainWindow;
        }

        public async Task<string?> PickFolderAsync()
        {
            var result = await _mainWindow.StorageProvider.OpenFolderPickerAsync(new FolderPickerOpenOptions
            {
                Title = "Select Save Location"
            });

            if (result.Count > 0)
            {
                return result[0].Path.LocalPath;
            }
            return null;
        }

        public void OpenFolder(string path)
        {
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                Process.Start(new ProcessStartInfo("explorer.exe", $"\"{path}\"") { UseShellExecute = true });
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            {
                Process.Start("xdg-open", path);
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                Process.Start("open", path);
            }
        }

        public void PlayFile(string filePath)
        {
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                Process.Start(new ProcessStartInfo("cmd", $"/c start \"\" \"{filePath}\"") { CreateNoWindow = true });
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            {
                Process.Start("xdg-open", filePath);
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                Process.Start("open", filePath);
            }
        }
    }
}
