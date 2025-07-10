using System;
using System.Windows.Input;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using VideoDownloaderApp.Services;
using VideoDownloaderApp.Views;

namespace VideoDownloaderApp.ViewModels
{
    public class MainWindowViewModel : ObservableObject
    {
        public NavigationService NavigationService { get; }

        public ICommand NavigateHomeCommand { get; }
        public ICommand NavigateDownloadsCommand { get; }
        public ICommand NavigateHistoryCommand { get; }
        public ICommand NavigateSettingsCommand { get; }
        public ICommand NavigateSupportCommand { get; }
        public ICommand ToggleSidebarCommand { get; }

        private object? _currentView;
        public object? CurrentView
        {
            get => _currentView;
            set => SetProperty(ref _currentView, value);
        }

        public MainWindowViewModel()
        {
            NavigationService = new NavigationService();

            NavigateHomeCommand = new RelayCommand(() => NavigationService.NavigateTo(NavigationPage.Home));
            NavigateDownloadsCommand = new RelayCommand(() => NavigationService.NavigateTo(NavigationPage.Downloads));
            NavigateHistoryCommand = new RelayCommand(() => NavigationService.NavigateTo(NavigationPage.History));
            NavigateSettingsCommand = new RelayCommand(() => NavigationService.NavigateTo(NavigationPage.Settings));
            NavigateSupportCommand = new RelayCommand(() => NavigationService.NavigateTo(NavigationPage.Support));
            ToggleSidebarCommand = new RelayCommand(() => NavigationService.ToggleSidebar());

            NavigationService.PropertyChanged += NavigationService_PropertyChanged;

            // Initialize with Home view
            NavigationService.NavigateTo(NavigationPage.Home);
        }

        private void NavigationService_PropertyChanged(object? sender, System.ComponentModel.PropertyChangedEventArgs e)
        {
            if (e.PropertyName == nameof(NavigationService.CurrentPage))
            {
                UpdateCurrentView();
            }
        }

        private void UpdateCurrentView()
        {
            switch (NavigationService.CurrentPage)
            {
                case NavigationPage.Home:
                    CurrentView = new HomeViewModel();
                    break;
                case NavigationPage.Downloads:
                    CurrentView = new DownloadsViewModel();
                    break;
                case NavigationPage.History:
                    CurrentView = new HistoryViewModel();
                    break;
                case NavigationPage.Settings:
                    CurrentView = new SettingsViewModel();
                    break;
                case NavigationPage.Support:
                    CurrentView = new SupportViewModel();
                    break;
                default:
                    CurrentView = null;
                    break;
            }
        }
    }
}
