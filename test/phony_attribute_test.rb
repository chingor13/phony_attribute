require 'test_helper'

class PhonyAttributeTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, PhonyAttribute
  end
end
