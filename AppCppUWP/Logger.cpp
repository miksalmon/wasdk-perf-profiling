#include "pch.h"
#include "Logger.h"
#if __has_include("Logger.g.cpp")
#include "Logger.g.cpp"
#endif

#include <winrt/Windows.Foundation.Diagnostics.h>
#include <winrt/Windows.System.Diagnostics.h>

using namespace winrt;
using namespace Windows::Foundation::Diagnostics;

namespace winrt::AppCppUWP::implementation
{
    thread_local AppCppUWP::Logger Logger::s_loggerInstance{ nullptr };

    Logger::Logger()
        :
        _loggingChannel{ LoggingChannel(L"LoggingChannel", nullptr, guid(L"2e0582f3-d1b6-516a-9de3-9fd79ef952f8")) },
        _initialTime{ clock::now() }
    {
    }

    AppCppUWP::Logger Logger::Singleton()
    {
        if (s_loggerInstance == nullptr)
        {
            s_loggerInstance = AppCppUWP::Logger();
        }

        return s_loggerInstance;
    }

    void Logger::Log(hstring const& eventName)
    {
        auto currentTime = clock::now();
        auto elapsedTime = std::chrono::duration<double, std::milli>(currentTime - _initialTime);

        LoggingFields fields;
        fields.AddString(L"eventName", eventName);
        fields.AddDouble(L"timeElapsed", elapsedTime.count());
        _loggingChannel.LogEvent(eventName, fields);
    }
}
