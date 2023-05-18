#pragma once

#include "SamplePage.g.h"

namespace winrt::AppCppUWP::implementation
{
    struct SamplePage : SamplePageT<SamplePage>
    {
        SamplePage();

        void Page_Loaded(winrt::Windows::Foundation::IInspectable const& sender, winrt::Windows::UI::Xaml::RoutedEventArgs const& e);
    };
}

namespace winrt::AppCppUWP::factory_implementation
{
    struct SamplePage : SamplePageT<SamplePage, implementation::SamplePage>
    {
    };
}
