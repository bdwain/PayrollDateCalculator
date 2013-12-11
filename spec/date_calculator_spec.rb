require 'date_calculator'

describe DateCalculator do
  describe "#initialize" do
    context "when date is not of the form MM/DD/YYYY" do
      it "raises an error" do
        expect{DateCalculator.new("05/123/19", "weekly")}.to raise_error("Invalid Date. Use form MM/DD/YYYY")
      end
    end

    context "when interval is not daily, weekly, bi-weekly, semi-monthly or monthly" do
      it "raises an error" do
        expect{DateCalculator.new("05/15/2013", "bad-interval")}.to raise_error("Invalid Interval. Please use daily, weekly, bi-weekly, semi-monthly or monthly")
      end
    end
  end
end