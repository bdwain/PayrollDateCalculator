require 'date_calculator'

describe DateCalculator do
  describe "#get_next_paydate" do
    it "raises an error" do
      expect{DateCalculator.new.get_all_paydates(Date.new(2013,1,1), Date.new(2013,1,2))}.to raise_error("Not implemented")
    end
  end
end