require 'daily_date_calculator'
require 'date_calculator_spec'

describe DailyDateCalculator do
  describe "#get_all_paydates" do
    let(:result) {DailyDateCalculator.new.get_all_paydates(start_date, end_date, holidays)}
    let(:start_date) {Date.new(2013,12,1)}
    let(:end_date) {Date.new(2014,2,1)}
    let(:holidays) {[]}

    it "returns all weekdays in start_date...end_date" do
      expect(result).to eq((start_date...end_date).to_a.select! {|day| day.wday != 0 && day.wday != 6})
    end

    context "when there are holidays" do
      let(:holidays) {[Date.new(2013,12,25), Date.new(2014,1,2)]}

      it "the holidays are excluded from the results" do
        expect(result).to eq((start_date...end_date).to_a.select! {|day| day.wday != 0 && day.wday != 6 && !holidays.include?(day)})
      end
    end
  end
end