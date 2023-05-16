using Microsoft.UI.Dispatching;
using Microsoft.UI.Xaml;
using Windows.ApplicationModel;

using MUX = Microsoft.UI.Xaml;

#nullable enable

namespace WinAppSdkActivationSampleApp;

public partial class App : Application
{
    private MainWindow? MainWindow { get; set; }

    public App()
    {
        _ = Logger.Instance;
        InitializeComponent();
    }

    protected override void OnLaunched(MUX.LaunchActivatedEventArgs args)
    {
        Logger.Instance.Log(nameof(OnLaunched));

        var appActivationArguments = AppInstance.GetActivatedEventArgs();
        var instanceArgs = appActivationArguments;

        MainWindow = new MainWindow(instanceArgs);
        MainWindow.Activate();
    }
}
