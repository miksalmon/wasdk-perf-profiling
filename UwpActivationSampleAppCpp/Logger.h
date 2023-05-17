#pragma once

#include "Logger.g.h"
#include <winrt/Windows.Foundation.Diagnostics.h>

namespace winrt::UwpActivationSampleAppCpp::implementation
{
    struct Logger : LoggerT<Logger>
    {
        Logger();

        void Log(winrt::hstring const& eventName);

        static UwpActivationSampleAppCpp::Logger Singleton();

    private:
        Windows::Foundation::Diagnostics::LoggingChannel _loggingChannel;
        Windows::Foundation::DateTime _initialTime;
        static thread_local UwpActivationSampleAppCpp::Logger s_loggerInstance;
    };
}

namespace winrt::UwpActivationSampleAppCpp::factory_implementation
{
    struct Logger : LoggerT<Logger, implementation::Logger>
    {
    };
}
