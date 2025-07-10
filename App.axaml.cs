
using System;
using Avalonia;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Data.Core;
using Avalonia.Data.Core.Plugins;
using System.Linq;
using Avalonia.Markup.Xaml;
using VideoDownloaderApp.ViewModels;
using VideoDownloaderApp.Views;

namespace VideoDownloaderApp;

public partial class App : Application
{
    public override void Initialize()
    {
        AvaloniaXamlLoader.Load(this);
    }

    public override async void OnFrameworkInitializationCompleted()
    {
        if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
        {
            DisableAvaloniaDataAnnotationValidation();

            var splash = new Views.SplashWindow();
            splash.Show();

            // Simulate loading delay (e.g., 3 seconds)
            await System.Threading.Tasks.Task.Delay(000);

            try
            {
                var mainWindow = new MainWindow
                {
                    DataContext = new MainWindowViewModel(),
                };

                desktop.MainWindow = mainWindow;
                mainWindow.Show();
                splash.Close();
            }
            catch (Exception ex)
            {
                splash.Close();
                System.Console.WriteLine("Exception during main window initialization: " + ex);
                throw;
            }
        }

        base.OnFrameworkInitializationCompleted();
    }

    private void DisableAvaloniaDataAnnotationValidation()
    {
        // Get an array of plugins to remove
        var dataValidationPluginsToRemove =
            BindingPlugins.DataValidators.OfType<DataAnnotationsValidationPlugin>().ToArray();

        // remove each entry found
        foreach (var plugin in dataValidationPluginsToRemove)
        {
            BindingPlugins.DataValidators.Remove(plugin);
        }
    }
}
