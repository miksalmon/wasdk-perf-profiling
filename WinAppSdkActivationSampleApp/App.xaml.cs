using Microsoft.UI.Xaml;

namespace WinAppSdkActivationSampleApp;

public partial class App : Application
{
    public App()
    {
        _ = Logger.Instance;
        InitializeComponent();
    }

    protected override void OnLaunched(Microsoft.UI.Xaml.LaunchActivatedEventArgs args)
    {
        Logger.Instance.Log(nameof(OnLaunched));
        m_window = new MainWindow();
        m_window.Activate();
    }

    private Window m_window;
}
