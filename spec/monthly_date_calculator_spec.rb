require 'monthly_date_calculator'
require 'date_calculator_spec'

describe MonthlyDateCalculator do
  describe "#get_all_paydates" do
    let(:result) {MonthlyDateCalculator.new.get_all_paydates(start_date, end_date)}
    let(:start_date) {Date.new(2013,12,16)} #monday
    let(:end_date) {Date.new(2014,1,31)}

    it "includes all days in start_date...end_date that have start_date's date" do
      expect(result).to eq((start_date...end_date).to_a.keep_if {|day| day.day == start_date.day})
    end

    context "when start_date is a saturday" do
      let(:start_date) {Date.new(2013,12,14)}
      let(:end_date) {Date.new(2014,1,31)}

      it "does not include start_date" do
        expect(result).not_to include(start_date)
      end
    end

    context "when start_date is a sunday" do
      let(:start_date) {Date.new(2013,12,15)}
      let(:end_date) {Date.new(2014,1,31)}

      it "includes all days in start_date...end_date that have start_date's date" do
        expect(result).not_to include(start_date)
      end
    end

    context "when a payday falls on a saturday" do
      let(:start_date) {Date.new(2013,12,18)}
      let(:end_date) {Date.new(2014,1,31)}

      it "excludes that payday" do
        expect(result).not_to include(Date.new(2014,1,18))
      end

      it "includes the previous friday from that payday" do
        expect(result).to include(Date.new(2014,1,17))
      end        
    end

    context "when a payday falls on a sunday" do
      let(:start_date) {Date.new(2013,12,19)}
      let(:end_date) {Date.new(2014,1,31)}

      it "excludes that payday" do
        expect(result).not_to include(Date.new(2014,1,19))
      end

      it "includes the previous friday from that payday" do
        expect(result).to include(Date.new(2014,1,17))
      end        
    end

    context "when end_date is on a weekend" do
      context "when start_date.day falls on that weekend but is outside of start_date...end_date" do
        let(:start_date) {Date.new(2013,12,11)}
        let(:end_date) {Date.new(2014,1,11)}

        it "includes the friday before end_date" do
          expect(result).to include (Date.new(2014,1,10))
        end
      end
    end

    context "when the start_date is the 31st" do
      context "when the following month has 30 days" do
        context "when the following month's 30th day is a weekday" do
          let(:start_date) {Date.new(2014,3,31)}
          let(:end_date) {Date.new(2014,5,1)}

          it "includes the following month's 30th day" do
            expect(result).to include(Date.new(2014,4,30))
          end
        end
        context "when the following month's 30th is a weekend" do
          let(:start_date) {Date.new(2013,10,31)}
          let(:end_date) {Date.new(2013,12,1)}

          it "includes the friday before the following month's 30th day" do
            expect(result).to include(Date.new(2013,11,29))
          end

          it "excludes the following month's 30th day" do
            expect(result).to_not include(Date.new(2013,11,30))
          end
        end
      end
    end

    context "when the date is after the 28th and the end of february is in the date range" do
      context "when not a leap year" do
        context "feburary 28th is a weekday" do
          let(:start_date) {Date.new(2013,1,29)}
          let(:end_date) {Date.new(2013,4,1)}

          it "includes feburary 28th" do
            expect(result).to include(Date.new(2013,2,28))
          end

          context "when the end of march is in the interval" do
            it "excludes march 28th" do
              expect(result).not_to include(Date.new(2013,3,28))
            end

            it "includes march the date in march corresponding to the start_date" do
              expect(result).to include(Date.new(2013,3,29))
            end
          end
        end

        context "when february 28th is a weekend" do
          let(:start_date) {Date.new(2010,1,29)}
          let(:end_date) {Date.new(2010,3,1)}

          it "includes the friday before february 28th" do
            expect(result).to include(Date.new(2010,2,26))
          end
        end
      end

      context "when it's a leap year" do
        context "when february 29th is a weekday" do
          let(:start_date) {Date.new(2012,1,30)}
          let(:end_date) {Date.new(2012,3,1)}

          it "includes feburary 29th" do
            expect(result).to include(Date.new(2012,2,29))
          end
        end

        context "february 29th is a weekend" do
          let(:start_date) {Date.new(2004,1,30)}
          let(:end_date) {Date.new(2004,3,1)}

          it "includes the friday before feburary 29th" do
            expect(result).to include(Date.new(2004,2,27))
          end
        end
      end
    end
  end
end