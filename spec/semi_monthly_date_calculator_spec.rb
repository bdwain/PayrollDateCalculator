require 'semi_monthly_date_calculator'
require 'monthly_calculator_spec_helper'

describe SemiMonthlyDateCalculator do
  describe "#get_all_paydates" do
    let(:result) {SemiMonthlyDateCalculator.new.get_all_paydates(start_date, end_date)}
    let(:start_date) {Date.new(2013,9,30)}
    let(:end_date) {Date.new(2013,11,1)}

    it "includes all days in start_date...end_date that are the last day of the month or the 15th" do
      expect(result).to eq((start_date...end_date).to_a.keep_if {|day| day.day == 15 || day.next_day.month != day.month})
    end

    include_examples "last day of the month MonthlyDateCalculator checks"

    context "when the 15th is a saturday" do
      let(:start_date) {Date.new(2013,6,1)}
      
      context "when the 15th is in the date range" do
        let(:end_date) {Date.new(2013,6,30)}

        it "includes the friday before the 15th" do
          expect(result).to include(Date.new(2013,6,14))
        end

        it "excludes the 15th" do
          expect(result).not_to include(Date.new(2013,6,15))
        end
      end

      context "when the 15th is not in the date range" do
        let(:end_date) {Date.new(2013,6,15)}

        it "includes the friday before the 15th" do
          expect(result).to include(Date.new(2013,6,14))
        end        
      end
    end

    context "when the 15th is a sunday" do
      let(:start_date) {Date.new(2013,12,1)}

      context "when the 15th is in the date range" do
        let(:end_date) {Date.new(2013,12,31)}

        it "includes the friday before the 15th" do
          expect(result).to include(Date.new(2013,12,13))
        end

        it "excludes the 15th" do
          expect(result).not_to include(Date.new(2013,12,15))
        end
      end

      context "when the 15th is not in the date range" do
        let(:end_date) {Date.new(2013,12,15)}

        it "includes the friday before the 15th" do
          expect(result).to include(Date.new(2013,12,13))
        end        
      end  
    end
  end
end