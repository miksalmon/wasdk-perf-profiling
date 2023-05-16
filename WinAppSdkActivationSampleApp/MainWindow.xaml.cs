using Microsoft.UI.Xaml;

namespace WinAppSdkActivationSampleApp;

public sealed partial class MainWindow : Window
{
    public MainWindow()
    {
        Logger.Instance.Log(nameof(MainWindow));
        this.InitializeComponent();
    }
}
