require_relative "../helpers/time_helpers"

class TestableTimeHelpers
  include TimeHelpers
end

RSpec.describe TimeHelpers do
  before do
    @helper = TestableTimeHelpers.new
  end

  describe "#parse_date" do
    it "parses a full date" do
      expected = Date.new(2021, 10, 1)
      expect(@helper.parse_date("2021-10-01")).to eq(expected)
    end
  end

  describe "#date" do
    it "throws an error for a malformed date" do
      expect { @helper.date("") }.to raise_error(Date::Error)
    end

    it "parses a date with only a month specified" do
      expect(@helper.date("2010-02")).to eq("<time datetime=\"2010-02\">Feb 2010</time>")
    end

    it "parses a full date" do
      expect(@helper.date("2021-10-01")).to eq("<time datetime=\"2021-10-01\">Oct 1, 2021</time>")
    end
  end
end
