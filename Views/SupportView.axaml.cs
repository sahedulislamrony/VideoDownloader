using Avalonia.Controls;
using Avalonia.Markup.Xaml;

namespace VideoDownloaderApp.Views
{
    public partial class SupportView : UserControl
    {
        public SupportView()
        {
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            AvaloniaXamlLoader.Load(this);
        }
    }
}
