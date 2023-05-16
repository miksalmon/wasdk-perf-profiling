using Microsoft.UI.Xaml;

#nullable enable

namespace WinAppSdkActivationSampleApp;

public sealed partial class MainWindow : Window
{
    public MainWindow(object? activationArgs)
    {
        InitializeComponent();
        ActivationArgs = activationArgs;
    }

    public object? ActivationArgs { get; }
}
