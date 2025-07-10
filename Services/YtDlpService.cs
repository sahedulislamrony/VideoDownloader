using System;
using System.Diagnostics;
using System.Threading.Tasks;

namespace VideoDownloaderApp.Services
{
    public class YtDlpService
    {
        private readonly string ytDlpPath = "yt-dlp"; // Assumes yt-dlp is in PATH or provide full path

        public async Task<string> FetchFormatsAsync(string url)
        {
            var args = $"-F \"{url}\"";
            return await RunProcessAsync(ytDlpPath, args);
        }

        public async Task<string> DownloadAsync(string url, string formatCode, string outputPath, string? renameTitle = null)
        {
            string outputTemplate = renameTitle != null ? $"{outputPath}/{renameTitle}.%(ext)s" : $"{outputPath}/%(title)s.%(ext)s";
            var args = $"-f {formatCode} -o \"{outputTemplate}\" \"{url}\"";
            return await RunProcessAsync(ytDlpPath, args);
        }

        private async Task<string> RunProcessAsync(string fileName, string arguments)
        {
            var tcs = new TaskCompletionSource<string>();

            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = fileName,
                    Arguments = arguments,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true,
                },
                EnableRaisingEvents = true
            };

            string output = "";
            process.OutputDataReceived += (sender, e) =>
            {
                if (e.Data != null)
                    output += e.Data + Environment.NewLine;
            };
            process.ErrorDataReceived += (sender, e) =>
            {
                if (e.Data != null)
                    output += e.Data + Environment.NewLine;
            };

            process.Exited += (sender, e) =>
            {
                tcs.SetResult(output);
                process.Dispose();
            };

            process.Start();
            process.BeginOutputReadLine();
            process.BeginErrorReadLine();

            return await tcs.Task;
        }
    }
}
