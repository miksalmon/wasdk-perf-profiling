using System;
using Windows.ApplicationModel;
using Windows.ApplicationModel.Activation;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Navigation;

namespace UwpActivationSampleApp
{
    sealed partial class App : Application
    {
        public App()
        {
            _ = Logger.Instance;
            InitializeComponent();
            Suspending += OnSuspending;
        }

        protected override void OnLaunched(LaunchActivatedEventArgs args)
        {
            Logger.Instance.Log(nameof(OnLaunched));
            LaunchActivate(args);
        }

        protected override void OnFileActivated(FileActivatedEventArgs args)
        {
            Logger.Instance.Log(nameof(OnFileActivated));
            FileActivate(args);
        }

        private void LaunchActivate(LaunchActivatedEventArgs args)
        {
            var frame = CreateFrame(args);

            if (args.PrelaunchActivated == false)
            {
                if (frame.Content == null)
                {
                    frame.Navigate(typeof(SamplePage), args.Arguments);
                }

                Window.Current.Activate();
            }
        }

        private void FileActivate(FileActivatedEventArgs args)
        {
            var frame = CreateFrame(args);

            if (frame.Content == null)
            {
                frame.Navigate(typeof(SamplePage), args.Files);
            }

            Window.Current.Activate();

        }

        private Frame CreateFrame(IActivatedEventArgs args)
        {
            if (!(Window.Current.Content is Frame rootFrame))
            {
                rootFrame = new Frame();

                rootFrame.NavigationFailed += OnNavigationFailed;

                Window.Current.Content = rootFrame;
            }

            return rootFrame;
        }

        private void OnNavigationFailed(object sender, NavigationFailedEventArgs e)
        {
            throw new Exception("Failed to load Page " + e.SourcePageType.FullName);
        }

        private void OnSuspending(object sender, SuspendingEventArgs e)
        {
            var deferral = e.SuspendingOperation.GetDeferral();
            //TODO: Save application state and stop any background activity
            deferral.Complete();
        }
    }
}
