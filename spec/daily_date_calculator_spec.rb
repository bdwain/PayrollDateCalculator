require 'daily_date_calculator'
require 'date_calculator_spec'

describe DailyDateCalculator do
  describe "#get_all_paydates" do
    let(:result) {DailyDateCalculator.new.get_all_paydates(start_date, end_date)}
    let(:start_date) {Date.new(2013,1,1)}
    let(:end_date) {Date.new(2013,5,1)}

    it "returns all weekdays in start_date...end_date" do
      expect(result).to eq((start_date...end_date).to_a.select! {|day| day.wday != 0 && day.wday != 6})
    end
  end
end