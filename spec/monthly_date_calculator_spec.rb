require 'monthly_date_calculator'
require 'monthly_calculator_spec_helper'

describe MonthlyDateCalculator do
  describe "#get_all_paydates" do
    let(:result) {MonthlyDateCalculator.new.get_all_paydates(start_date, end_date)}
    let(:start_date) {Date.new(2013,12,16)}
    let(:end_date) {Date.new(2014,1,31)}

    it "includes all days in start_date...end_date that are the last day of the month" do
      expect(result).to eq((start_date...end_date).to_a.keep_if {|day| day.next_day.month != day.month})
    end

    include_examples "last day of the month MonthlyDateCalculator checks"
  end
end