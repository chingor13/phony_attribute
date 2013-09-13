require 'test_helper'

class PhoneNumberTest < ActiveSupport::TestCase

  test "a blocked number" do
    pn = PhonyAttribute::PhoneNumber.parse("7378742833")
    assert(pn.blocked?)
  end

  context "parsing" do
    should "work for standard formats" do
      [
        "2065556667",
        "206-555-6667",
        "206.555.6667",
        "(206)555-6667",
        "+12065556667",
        "+1 206 555 6667",
        "+1-206-555-6667",
        "+1 (206)555-6667",
      ].each do |format|
        pn = PhonyAttribute::PhoneNumber.parse(format)
        assert(pn.plausible?)
        assert_equal("+12065556667", pn.format(:db))
      end
    end

    should "not accept bad formats" do
      [
        "awefwalef",
        "206awefae",
        "206x1234512",
      ].each do |format|
        begin
          pn = PhonyAttribute::PhoneNumber.parse(format)
          assert(!pn.valid?, "#{format} should not be a valid phone number")
        rescue
        end
      end
    end
  end

  context "database model validations" do
    should "handle bad phone numbers" do
      u = User.new({
        name: "Jeff",
        phone_number: "206asdf"
      })
      assert(!u.valid?, "#{u.phone_number} should not be a plausible phone number")
      assert(u.errors[:phone_number].present?, "should have errors on number")
    end

    should "format phone numbers before going to the database" do
      u = User.new({
        name: "Jeff",
        phone_number: "2065556667"
      })
      assert_difference "User.count", 1 do
        assert(u.save)
      end

      user = User.find(u.id)
      assert_equal("+12065556667", u.phone_number.format(:db), 'phone number should persist')
    end
  end

end
