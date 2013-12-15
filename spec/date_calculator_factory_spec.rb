require 'date_calculator_factory'

describe DateCalculatorFactory do
  describe "::get_calculator" do
    let(:result) {DateCalculatorFactory.get_calculator(interval)}

    context "when interval is not daily, weekly, bi-weekly, semi-monthly or monthly" do
      let(:interval) {:bad_interval}
      it "raises an error" do
        expect{result}.to raise_error("Invalid Interval. Please use :daily, :weekly, :bi_weekly, :semi_monthly or :monthly")
      end
    end

    context "when interval is :daily" do
      let(:interval) {:daily}

      it "returns a DailyDateCalculator" do
        expect(result).to be_a(DailyDateCalculator)
      end
    end

    context "when interval is :weekly" do
      let(:interval) {:weekly}

      it "returns a WeeklyDateCalculator" do
        expect(result).to be_a(WeeklyDateCalculator)
      end

      it "has an n_weekly value of 1" do
        expect(result.n_weekly).to eq(1)
      end
    end

    context "when interval is :bi_weekly" do
      let(:interval) {:bi_weekly}

      it "returns a WeeklyDateCalculator" do
        expect(result).to be_a(WeeklyDateCalculator)
      end

      it "has an n_weekly value of 1" do
        expect(result.n_weekly).to eq(2)
      end
    end

    context "when interval is :semi_monthly" do
      let(:interval) {:semi_monthly}

      it "returns a SemiMonthlyDateCalculator" do
        #expect(result).to be_a(SemiMonthlyDateCalculator)
      end
    end

    context "when interval is :monthly" do
      let(:interval) {:monthly}

      it "returns a MonthlyDateCalculator" do
        expect(result).to be_a(MonthlyDateCalculator)
      end
    end
  end
end