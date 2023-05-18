#pragma once

#include "Logger.g.h"
#include <winrt/Windows.Foundation.Diagnostics.h>

namespace winrt::AppCppUWP::implementation
{
    struct Logger : LoggerT<Logger>
    {
        Logger();

        void Log(winrt::hstring const& eventName);

        static AppCppUWP::Logger Singleton();

    private:
        Windows::Foundation::Diagnostics::LoggingChannel _loggingChannel;
        Windows::Foundation::DateTime _initialTime;
        static thread_local AppCppUWP::Logger s_loggerInstance;
    };
}

namespace winrt::AppCppUWP::factory_implementation
{
    struct Logger : LoggerT<Logger, implementation::Logger>
    {
    };
}
