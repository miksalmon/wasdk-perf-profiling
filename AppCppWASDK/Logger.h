#pragma once

#include "Logger.g.h"
#include <winrt/Windows.Foundation.Diagnostics.h>

namespace winrt::AppCppWASDK::implementation
{
    struct Logger : LoggerT<Logger>
    {
        Logger();

        void Log(winrt::hstring const& eventName);

        static AppCppWASDK::Logger Singleton();

    private:
        Windows::Foundation::Diagnostics::LoggingChannel _loggingChannel;
        Windows::Foundation::DateTime _initialTime;
        static thread_local AppCppWASDK::Logger s_loggerInstance;
    };
}

namespace winrt::AppCppWASDK::factory_implementation
{
    struct Logger : LoggerT<Logger, implementation::Logger>
    {
    };
}
