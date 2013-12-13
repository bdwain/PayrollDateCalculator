require 'date_calculator'

describe DateCalculator do
  describe "#initialize" do
    context "when start_date is not a Date object" do
      it "raises an error" do
        expect{DateCalculator.new("hello", "weekly")}.to raise_error("Please pass in a valid Date object")
      end
    end

    context "when interval is not daily, weekly, bi-weekly, semi-monthly or monthly" do
      it "raises an error" do
        expect{DateCalculator.new(Date.new(2013, 1, 1), "bad-interval")}.to raise_error("Invalid Interval. Please use daily, weekly, bi-weekly, semi-monthly or monthly")
      end
    end
  end
end