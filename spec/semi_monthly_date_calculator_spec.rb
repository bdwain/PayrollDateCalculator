require 'semi_monthly_date_calculator'
require 'monthly_calculator_spec_helper'

describe SemiMonthlyDateCalculator do
  describe "#get_all_paydates" do
    let(:result) {SemiMonthlyDateCalculator.new.get_all_paydates(start_date, end_date, holidays)}
    let(:start_date) {Date.new(2013,9,30)}
    let(:end_date) {Date.new(2013,11,1)}
    let(:holidays) {[]}

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

    context "when the 15th is a holiday" do
      let(:start_date) {Date.new(2013,11,1)}
      let(:end_date) {Date.new(2013,12,1)}
      let(:holidays) {[Date.new(2013,11,15)]}

      it "excludes the regular payday" do
        expect(result).to_not include(holidays[0])
      end

      it "includes the day before the holiday" do
        expect(result).to include(Date.new(2013,11,14))
      end

      context "when the holiday is also the end date" do
        let(:end_date) {holidays[0]}

        it "includes the day before the holiday" do
          expect(result).to include(Date.new(2013,11,14))
        end
      end

      context "when there are a combination of holidays and weekends leading up to the 15th" do
        let(:holidays) {[Date.new(2013,11,15), Date.new(2013,11,14), Date.new(2013,11,13), Date.new(2013,11,12), Date.new(2013,11,11)]}

        it "excludes all of the holidays" do
          holidays.each do |day|
            expect(result).to_not include(day)
          end
        end

        it "excludes all of the weekends" do
          expect(result).to_not include(Date.new(2013,11,10))
          expect(result).to_not include(Date.new(2013,11,9))
        end

        it "includes the last non holiday non weekday before the payday" do
          expect(result).to include(Date.new(2013,11,8))
        end

        context "when the holiday is also the end_date" do
          let(:end_date) {holidays[0]}

          it "includes the last valid payday in the interval" do
            expect(result).to include(Date.new(2013,11,8))
          end
        end
      end
    end
  end
end