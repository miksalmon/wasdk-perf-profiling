using Windows.UI.Xaml.Controls;

namespace UwpActivationSampleApp
{
    public sealed partial class SamplePage : Page
    {
        public SamplePage()
        {
            Logger.Instance.Log(nameof(SamplePage));
            InitializeComponent();
            Loaded += SamplePage_Loaded;
        }

        private void SamplePage_Loaded(object sender, Windows.UI.Xaml.RoutedEventArgs e)
        {
            Logger.Instance.Log(nameof(SamplePage_Loaded));
        }
    }
}
