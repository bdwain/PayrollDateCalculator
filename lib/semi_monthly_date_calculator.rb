require_relative 'monthly_date_calculator'

class SemiMonthlyDateCalculator < MonthlyDateCalculator
  def get_all_paydates(start_date, end_date)
    get_all_paydates_on_days(start_date, end_date, [15, 31]) #pay on the 15th and last day of the month
  end
end