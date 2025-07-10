using System;
using System.Diagnostics;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;

namespace VideoDownloaderApp.Installer
{
    class DependencyInstaller
    {
        private static readonly HttpClient httpClient = new HttpClient();
        
        static async Task Main(string[] args)
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
