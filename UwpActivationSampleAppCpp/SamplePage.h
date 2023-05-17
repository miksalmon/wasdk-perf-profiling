#pragma once

#include "SamplePage.g.h"

namespace winrt::UwpActivationSampleAppCpp::implementation
{
    struct SamplePage : SamplePageT<SamplePage>
    {
        SamplePage();

        void Page_Loaded(winrt::Windows::Foundation::IInspectable const& sender, winrt::Windows::UI::Xaml::RoutedEventArgs const& e);
    };
}

namespace winrt::UwpActivationSampleAppCpp::factory_implementation
{
    struct SamplePage : SamplePageT<SamplePage, implementation::SamplePage>
    {
    };
}
