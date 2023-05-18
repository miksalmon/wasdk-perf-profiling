#include "pch.h"
#include "SamplePage.h"
#include "SamplePage.g.cpp"

using namespace winrt;
using namespace Windows::UI::Xaml;

namespace winrt::AppCppUWP::implementation
{
    SamplePage::SamplePage()
    {
        Logger::Singleton().Log(L"SamplePage");
    }

    void SamplePage::Page_Loaded(winrt::Windows::Foundation::IInspectable const& sender, RoutedEventArgs const& e)
    {
        Logger::Singleton().Log(L"SamplePage_Loaded");
    }
}
