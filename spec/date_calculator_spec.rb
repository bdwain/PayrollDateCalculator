require 'date_calculator'

describe DateCalculator do
  describe "#initialize" do
    context "when date is not of the form MM/DD/YYYY" do
      let(:date) {"05/123/19"}
      specify do
        expect{DateCalculator.new(date, "weekly")}.to raise_error("Invalid Date. Use form MM/DD/YYYY")
      end
    end
  end
end