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
    let(:result) {WeeklyDateCalculator.new(n_weekly).get_all_paydates(start_date, end_date)}

    context "when n_weekly is 1" do
      let(:n_weekly) {1}
      context "when the start_date is a weekday" do
        let(:start_date) {Date.new(2013,12,3)}
        let(:end_date) {Date.new(2014,5,1)}

        it "returns all instances of that day of the week in start_date...end_date" do
          expect(result).to eq((start_date...end_date).to_a.select! {|day| day.wday == 2})
        end
      end

      context "when the start_date is a saturday" do
        let(:start_date) {Date.new(2013,12,7)}
        let(:end_date) {Date.new(2014,12,1)}

        it "returns all fridays in start_date...end_date" do
          expect(result).to eq((start_date...end_date).to_a.select! {|day| day.wday == 5})
        end

        context "when end_date is saturday" do
          let(:end_date) {Date.new(2013,12,14)}

          it "includes the friday before end_date" do
            expect(result).to include(end_date-1)
          end
        end
      end

      context "when the start_date is a sunday" do
        let(:start_date) {Date.new(2013,12,8)}
        let(:end_date) {Date.new(2014,12,1)}

        it "returns all fridays in start_date...end_date" do
          expect(result).to eq((start_date...end_date).to_a.select! {|day| day.wday == 5})
        end

        context "when end_date is on the weekend" do
          let(:end_date) {Date.new(2013,12,14)}
          it "includes the friday before end_date" do
            expect(result).to include(end_date-1)
          end
        end        
      end
    end

    context "when n_weekly is greater than 1" do
      let(:n_weekly) {2}

      context "when the start_date is a weekday" do
        let(:start_date) {Date.new(2013,12,5)}
        let(:end_date) {Date.new(2014,4,1)}

        it "returns every nth instance of that weekday in start_date...end_date (starting with the first)" do
          expected_result = (start_date...end_date).to_a.select! {|day| day.wday == 4}
          expected_result = expected_result.select.each_with_index { |day, i| i % n_weekly == 0 }
          expect(result).to eq(expected_result)
        end
      end

      context "when the start_date is a saturday" do
        let(:start_date) {Date.new(2013,12,7)}
        let(:end_date) {Date.new(2014,12,1)}

        it "returns every nth friday in start_date...end_date (starting with the nth)" do
          expected_result = (start_date...end_date).to_a.select! {|day| day.wday == 5}
          expected_result = expected_result.select.each_with_index { |day, i| (i+1) % n_weekly == 0 }
          expect(result).to eq(expected_result)
        end

        context "when end_date is a saturday that is a multiple of n weeks after start_date" do
          let(:end_date) {Date.new(2013,12,21)}

          it "includes the friday before end_date" do
            expect(result).to include(end_date-1)
          end
        end        
      end

      context "when the start_date is a sunday" do
        let(:start_date) {Date.new(2013,12,8)}
        let(:end_date) {Date.new(2014,12,1)}

        it "returns every nth friday in start_date...end_date (starting with the nth)" do
          expected_result = (start_date...end_date).to_a.select! {|day| day.wday == 5}
          expected_result = expected_result.select.each_with_index { |day, i| (i+1) % n_weekly == 0 }
          expect(result).to eq(expected_result)
        end

        context "when end_date is on a weekend that is a multiple of n weeks after start_date" do
          let(:end_date) {Date.new(2013,12,21)}

          it "includes the friday before end_date" do
            expect(result).to include(end_date-1)
          end
        end           
      end
    end
  end
end