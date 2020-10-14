require 'test_helper'
require 'ood_appkit'
require 'climate_control'

class ConfigurationTest < ActiveSupport::TestCase

  test "default page_title_prefix" do
    # not sure how to get the rails magic to work here
    OodAppkit.set_default_configuration
    assert_equal "Open OnDemand", OodAppkit.page_title_prefix # default prefix
  end

  test "page_title_prefix set through OOD_DASHBOARD_TITLE" do
    ClimateControl.modify OOD_DASHBOARD_TITLE: 'VT OnDemand' do
      OodAppkit.set_default_configuration
      assert_equal "VT OnDemand", OodAppkit.page_title_prefix
    end
  end

  test "page_title_prefix set through PAGE_TITLE_PREFIX" do
    ClimateControl.modify PAGE_TITLE_PREFIX: 'OSC OnDemand' do
      OodAppkit.set_default_configuration
      assert_equal "OSC OnDemand", OodAppkit.page_title_prefix
    end
  end

  test "page_title_prefix set through PAGE_TITLE_PREFIX with OOD_DASHBOARD_TITLE also set" do
    # uses PAGE_TITLE_PREFIX with higher precedence
    ClimateControl.modify OOD_DASHBOARD_TITLE: 'VT OnDemand', PAGE_TITLE_PREFIX: 'OSC OnDemand' do
      OodAppkit.set_default_configuration
      assert_equal "OSC OnDemand", OodAppkit.page_title_prefix # default prefix
    end
  end

end