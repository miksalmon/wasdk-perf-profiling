#pragma once

#include "Logger.g.h"
#include <winrt/Windows.Foundation.Diagnostics.h>

namespace winrt::WinAppSdkActivationSampleAppCpp::implementation
{
    struct Logger : LoggerT<Logger>
    {
        Logger();

        void Log(winrt::hstring const& eventName);

        static WinAppSdkActivationSampleAppCpp::Logger Singleton();

    private:
        Windows::Foundation::Diagnostics::LoggingChannel _loggingChannel;
        Windows::Foundation::DateTime _initialTime;
        static thread_local WinAppSdkActivationSampleAppCpp::Logger s_loggerInstance;
    };
}

namespace winrt::WinAppSdkActivationSampleAppCpp::factory_implementation
{
    struct Logger : LoggerT<Logger, implementation::Logger>
    {
    };
}
