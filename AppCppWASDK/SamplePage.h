#pragma once

#include "SamplePage.g.h"

namespace winrt::AppCppWASDK::implementation
{
    struct SamplePage : SamplePageT<SamplePage>
    {
        SamplePage();

        void Page_Loaded(winrt::Windows::Foundation::IInspectable const& sender, winrt::Microsoft::UI::Xaml::RoutedEventArgs const& e);
    };
}

namespace winrt::AppCppWASDK::factory_implementation
{
    struct SamplePage : SamplePageT<SamplePage, implementation::SamplePage>
    {
    };
}
