using System;
using System.Diagnostics;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;
using System.IO.Compression;
using System.Linq;

namespace VideoDownloaderApp.Installer
{
    class DependencyInstaller
    {
        private static readonly HttpClient httpClient = new HttpClient();

        static async Task DependencyInstallerMain(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("Usage: DependencyInstaller.exe <command>");
                return;
            }

            try
            {
                switch (args[0].ToLower())
                {
                    case "install-dotnet":
                        await InstallDotNetRuntime();
                        break;
                    case "install-ytdlp":
                        await InstallYtDlp();
                        break;
                    case "install-ffmpeg":
                        await InstallFFmpeg();
                        break;
                    default:
                        Console.WriteLine($"Unknown command: {args[0]}");
                        break;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                Environment.Exit(1);
            }
        }

        static async Task InstallDotNetRuntime()
        {
            Console.WriteLine("Checking .NET 8.0 Runtime...");

            // Check if .NET 8.0 is already installed
            try
            {
                var process = Process.Start(new ProcessStartInfo
                {
                    FileName = "dotnet",
                    Arguments = "--list-runtimes",
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                });

                if (process != null)
                {
                    var output = await process.StandardOutput.ReadToEndAsync();
                    await process.WaitForExitAsync();

                    if (output.Contains("Microsoft.NETCore.App 8.0"))
                    {
                        Console.WriteLine(".NET 8.0 Runtime already installed.");
                        return;
                    }
                }
            }
            catch
            {
                // dotnet command not found, proceed with installation
            }

            Console.WriteLine("Installing .NET 8.0 Runtime...");

            // Download and install .NET Runtime
            var runtimeUrl = "https://download.microsoft.com/download/6/0/f/60fc8ea7-d5d1-4c7b-b24e-4d8b7a4b6e8a/windowsdesktop-runtime-8.0.0-win-x64.exe";
            var tempPath = Path.GetTempFileName() + ".exe";

            try
            {
                using (var response = await httpClient.GetAsync(runtimeUrl))
                {
                    using (var fileStream = File.Create(tempPath))
                    {
                        await response.Content.CopyToAsync(fileStream);
                    }
                }

                var installProcess = Process.Start(new ProcessStartInfo
                {
                    FileName = tempPath,
                    Arguments = "/quiet",
                    UseShellExecute = true
                });

                if (installProcess != null)
                {
                    await installProcess.WaitForExitAsync();
                }

                Console.WriteLine(".NET 8.0 Runtime installation completed.");
            }
            finally
            {
                if (File.Exists(tempPath))
                    File.Delete(tempPath);
            }
        }

        static async Task InstallYtDlp()
        {
            Console.WriteLine("Installing yt-dlp...");

            // Check if yt-dlp is already available
            try
            {
                var checkProcess = Process.Start(new ProcessStartInfo
                {
                    FileName = "yt-dlp",
                    Arguments = "--version",
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                });

                if (checkProcess != null)
                {
                    await checkProcess.WaitForExitAsync();
                    if (checkProcess.ExitCode == 0)
                    {
                        Console.WriteLine("yt-dlp already installed.");
                        return;
                    }
                }
            }
            catch
            {
                // yt-dlp not found, proceed with installation
            }

            // Download yt-dlp
            var ytdlpUrl = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe";
            var programFiles = Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles);
            var installPath = Path.Combine(programFiles, "VideoDownloaderApp", "yt-dlp.exe");

            Directory.CreateDirectory(Path.GetDirectoryName(installPath)!);

            using (var response = await httpClient.GetAsync(ytdlpUrl))
            {
                using (var fileStream = File.Create(installPath))
                {
                    await response.Content.CopyToAsync(fileStream);
                }
            }

            // Add to PATH
            var currentPath = Environment.GetEnvironmentVariable("PATH", EnvironmentVariableTarget.Machine);
            var ytdlpDir = Path.GetDirectoryName(installPath);

            if (currentPath != null && !currentPath.Contains(ytdlpDir!))
            {
                Environment.SetEnvironmentVariable("PATH",
                    currentPath + ";" + ytdlpDir,
                    EnvironmentVariableTarget.Machine);
            }

            Console.WriteLine("yt-dlp installation completed.");
        }

        static async Task InstallFFmpeg()
        {
            Console.WriteLine("Installing FFmpeg...");

            // Check if ffmpeg is already available
            try
            {
                var checkProcess = Process.Start(new ProcessStartInfo
                {
                    FileName = "ffmpeg",
                    Arguments = "-version",
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                });

                if (checkProcess != null)
                {
                    await checkProcess.WaitForExitAsync();
                    if (checkProcess.ExitCode == 0)
                    {
                        Console.WriteLine("FFmpeg already installed.");
                        return;
                    }
                }
            }
            catch
            {
                // ffmpeg not found, proceed with installation
            }

            // Download FFmpeg (using a static build)
            var ffmpegUrl = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip";
            var tempZip = Path.GetTempFileName() + ".zip";
            var programFiles = Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles);
            var extractPath = Path.Combine(programFiles, "VideoDownloaderApp", "ffmpeg");

            try
            {
                using (var response = await httpClient.GetAsync(ffmpegUrl))
                {
                    using (var fileStream = File.Create(tempZip))
                    {
                        await response.Content.CopyToAsync(fileStream);
                    }
                }

                // Extract FFmpeg
                ZipFile.ExtractToDirectory(tempZip, extractPath);

                // Find the bin directory and add to PATH
                var binPath = Directory.GetDirectories(extractPath, "*", SearchOption.AllDirectories)
                    .FirstOrDefault(d => Path.GetFileName(d) == "bin");

                if (binPath != null)
                {
                    var currentPath = Environment.GetEnvironmentVariable("PATH", EnvironmentVariableTarget.Machine);
                    if (currentPath != null && !currentPath.Contains(binPath))
                    {
                        Environment.SetEnvironmentVariable("PATH",
                            currentPath + ";" + binPath,
                            EnvironmentVariableTarget.Machine);
                    }
                }

                Console.WriteLine("FFmpeg installation completed.");
            }
            finally
            {
                if (File.Exists(tempZip))
                    File.Delete(tempZip);
            }
        }
    }
}
