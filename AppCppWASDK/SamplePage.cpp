#include "pch.h"
#include "SamplePage.h"
#if __has_include("SamplePage.g.cpp")
#include "SamplePage.g.cpp"
#endif

using namespace winrt;
using namespace Windows::UI::Xaml;

namespace winrt::AppCppWASDK::implementation
{
    SamplePage::SamplePage()
    {
        Logger::Singleton().Log(L"SamplePage");
    }

    void SamplePage::Page_Loaded(winrt::Windows::Foundation::IInspectable const& sender, winrt::Microsoft::UI::Xaml::RoutedEventArgs const& e)
    {
        Logger::Singleton().Log(L"SamplePage_Loaded");
    }
}
