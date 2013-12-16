require 'monthly_date_calculator'
require 'date_calculator_spec'

describe MonthlyDateCalculator do
  describe "#get_all_paydates" do
    let(:result) {MonthlyDateCalculator.new.get_all_paydates(start_date, end_date)}
    let(:start_date) {Date.new(2013,12,16)}
    let(:end_date) {Date.new(2014,1,31)}

    it "includes all days in start_date...end_date that are the last day of the month" do
      expect(result).to eq((start_date...end_date).to_a.keep_if {|day| day.next_day.month != day.month})
    end

    context "when the last day of the month is a saturday" do
      let(:start_date) {Date.new(2013,8,1)}
      
      context "when the last day of the month is in the date range" do
        let(:end_date) {Date.new(2013,9,1)}

        it "includes the friday before the last day" do
          expect(result).to include(Date.new(2013,8,30))
        end

        it "excludes the last day of the month" do
          expect(result).not_to include(Date.new(2013,8,31))
        end
      end

      context "when the last day of the month is not in the date range" do
        let(:end_date) {Date.new(2013,8,31)}

        it "includes the friday before the last day" do
          expect(result).to include(Date.new(2013,8,30))
        end        
      end
    end

    context "when the last day of the month is a sunday" do
      let(:start_date) {Date.new(2013,6,1)}

      context "when the last day of the month is in the date range" do
        let(:end_date) {Date.new(2013,7,1)}

        it "includes the friday before the last day" do
          expect(result).to include(Date.new(2013,6,28))
        end

        it "excludes the last day of the month" do
          expect(result).not_to include(Date.new(2013,6,30))
        end
      end

      context "when the last day of the month is not in the date range" do
        let(:end_date) {Date.new(2013,6,30)}

        it "includes the friday before the last day" do
          expect(result).to include(Date.new(2013,6,28))
        end        
      end  
    end

    context "when it's a leap year" do
      context "when the date range covers the end of february" do
        context "when february 29th is a weekday" do
          let(:start_date) {Date.new(2012,1,30)}
          let(:end_date) {Date.new(2012,3,1)}

          it "includes feburary 29th" do
            expect(result).to include(Date.new(2012,2,29))
          end

          it "excludes february 28th" do
            expect(result).not_to include(Date.new(2012,2,28))
          end
        end

        context "february 29th is a weekend" do
          let(:start_date) {Date.new(2004,1,30)}
          let(:end_date) {Date.new(2004,3,1)}

          it "includes the friday before feburary 29th" do
            expect(result).to include(Date.new(2004,2,27))
          end

          it "excludes feburary 29th" do
            expect(result).not_to include(Date.new(2004,2,29))
          end
        end
      end
    end

  end
end