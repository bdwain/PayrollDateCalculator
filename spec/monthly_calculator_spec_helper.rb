shared_examples_for "last day of the month MonthlyDateCalculator checks" do
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

  context "when the last day of the month is a holiday" do
    let(:start_date) {Date.new(2013,12,1)}
    let(:end_date) {Date.new(2014,1,1)}
    let(:holidays) {[Date.new(2013,12,31)]}

    it "excludes the regular payday" do
      expect(result).to_not include(holidays[0])
    end

    it "includes the day before the holiday" do
      expect(result).to include(Date.new(2013,12,30))
    end

    context "when the holiday is also the end date" do
      let(:end_date) {holidays[0]}

      it "includes the day before the holiday" do
        expect(result).to include(Date.new(2013,12,30))
      end
    end

    context "when there are a combination of holidays and weekends leading up to a payday" do
      let(:holidays) {[Date.new(2013,12,31), Date.new(2013,12,30)]}

      it "excludes all of the holidays" do
        holidays.each do |day|
          expect(result).to_not include(day)
        end
      end

      it "excludes all of the weekends" do
        expect(result).to_not include(Date.new(2013,12,29))
        expect(result).to_not include(Date.new(2013,12,28))
      end

      it "includes the last non holiday non weekday before the payday" do
        expect(result).to include(Date.new(2013,12,27))
      end

      context "when the holiday is also the end_date" do
        let(:end_date) {holidays[0]}

        it "includes the last valid payday in the interval" do
          expect(result).to include(Date.new(2013,12,27))
        end
      end
    end
  end
end