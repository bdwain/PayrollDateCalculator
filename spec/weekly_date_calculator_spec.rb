require 'weekly_date_calculator'

describe WeeklyDateCalculator do
  describe "#initialize" do
    context "when n_weekly is not an integer" do
      it "raises an error" do
        expect{WeeklyDateCalculator.new("foo")}.to raise_error("n_weekly should be a positive integer")
      end
    end

    context "when n_weekly is a non-positive integer" do
      it "raises an error" do
        expect{WeeklyDateCalculator.new(0)}.to raise_error("n_weekly should be a positive integer")
      end
    end    
  end

  describe "#get_all_paydates" do
    let(:result) {WeeklyDateCalculator.new(n_weekly).get_all_paydates(start_date, end_date, holidays)}
    let(:holidays) {[]}

    context "when n_weekly is 1" do
      let(:n_weekly) {1}
      let(:start_date) {Date.new(2013,12,3)}
      let(:end_date) {Date.new(2014,1,1)}

      it "includes all fridays in start_date...end_date" do
        expect(result).to eq((start_date...end_date).to_a.select!{|day| day.wday == 5})
      end

      context "when end_date is a friday" do
        let(:end_date) {Date.new(2013,12,13)}

        it "does not include end_date" do
          expect(result).to_not include(end_date)
        end
      end
    end

    context "when n_weekly is greater than 1" do
      let(:n_weekly) {2}

      context "when the start_date is a weekday" do
        let(:start_date) {Date.new(2013,12,5)}
        let(:end_date) {Date.new(2014,4,1)}

        it "returns every nth instance of friday in start_date...end_date (starting with the first)" do
          expected_result = (start_date...end_date).to_a.select! {|day| day.wday == 5}
          expected_result = expected_result.select.each_with_index { |day, i| i % n_weekly == 0 }
          expect(result).to eq(expected_result)
        end
      end

      context "when the start_date is a saturday" do
        let(:start_date) {Date.new(2013,12,7)}
        let(:end_date) {Date.new(2014,4,1)}

        it "returns every nth friday in start_date...end_date (starting with the nth)" do
          expected_result = (start_date...end_date).to_a.select! {|day| day.wday == 5}
          expected_result = expected_result.select.each_with_index { |day, i| (i+1) % n_weekly == 0 }
          expect(result).to eq(expected_result)
        end
      end

      context "when the start_date is a sunday" do
        let(:start_date) {Date.new(2013,12,8)}
        let(:end_date) {Date.new(2014,4,1)}

        it "returns every nth friday in start_date...end_date (starting with the nth)" do
          expected_result = (start_date...end_date).to_a.select! {|day| day.wday == 5}
          expected_result = expected_result.select.each_with_index { |day, i| (i+1) % n_weekly == 0 }
          expect(result).to eq(expected_result)
        end        
      end
    end

    context "when there is a holiday on a payday" do
      let(:n_weekly) {1}
      let(:start_date) {Date.new(2013,12,1)}
      let(:end_date) {Date.new(2014,1,1)}
      let(:holidays) {[Date.new(2013,12,6)]}

      it "excludes the regular payday" do
        expect(result).to_not include(holidays[0])
      end

      it "includes the day before the holiday" do
        expect(result).to include(Date.new(2013,12,5))
      end

      context "when the holiday is also the end_date" do
        let(:end_date) {holidays[0]}

        it "includes the last valid payday in the interval" do
          expect(result).to include(Date.new(2013,12,5))
        end
      end

      context "when there are multiple holidays leading up to a payday" do
        let(:holidays) {[Date.new(2013,12,6), Date.new(2013,12,5), Date.new(2013,12,4)]}

        it "excludes all of the holidays" do
          holidays.each do |day|
            expect(result).to_not include(day)
          end
        end

        it "includes the last non holiday before the payday" do
          expect(result).to include(Date.new(2013,12,3))
        end

        context "when the holiday is also the end_date" do
          let(:end_date) {holidays[0]}

          it "includes the last valid payday in the interval" do
            expect(result).to include(Date.new(2013,12,3))
          end
        end        
      end
    end
  end
end