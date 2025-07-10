using System;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;

namespace VideoDownloaderApp.Services
{
    public enum NavigationPage
    {
        Home,
        Downloads,
        History,
        Settings,
        Support
    }

    public class NavigationService : ObservableObject
    {
        private NavigationPage _currentPage = NavigationPage.Home;
        public NavigationPage CurrentPage
        {
            get => _currentPage;
            set => SetProperty(ref _currentPage, value);
        }

        private bool _isSidebarExpanded = true;
        public bool IsSidebarExpanded
        {
            get => _isSidebarExpanded;
            set => SetProperty(ref _isSidebarExpanded, value);
        }

        public void NavigateTo(NavigationPage page)
        {
            CurrentPage = page;
        }

        public void ToggleSidebar()
        {
            IsSidebarExpanded = !IsSidebarExpanded;
        }

        // ICommand properties for binding
        private RelayCommand? _toggleSidebarCommand;
        public RelayCommand ToggleSidebarCommand => _toggleSidebarCommand ??= new RelayCommand(() => ToggleSidebar());

        private RelayCommand? _navigateHomeCommand;
        public RelayCommand NavigateHomeCommand => _navigateHomeCommand ??= new RelayCommand(() => NavigateTo(NavigationPage.Home));

        private RelayCommand? _navigateDownloadsCommand;
        public RelayCommand NavigateDownloadsCommand => _navigateDownloadsCommand ??= new RelayCommand(() => NavigateTo(NavigationPage.Downloads));

        private RelayCommand? _navigateHistoryCommand;
        public RelayCommand NavigateHistoryCommand => _navigateHistoryCommand ??= new RelayCommand(() => NavigateTo(NavigationPage.History));

        private RelayCommand? _navigateSettingsCommand;
        public RelayCommand NavigateSettingsCommand => _navigateSettingsCommand ??= new RelayCommand(() => NavigateTo(NavigationPage.Settings));

        private RelayCommand? _navigateSupportCommand;
        public RelayCommand NavigateSupportCommand => _navigateSupportCommand ??= new RelayCommand(() => NavigateTo(NavigationPage.Support));
    }
}
