require_relative 'daily_date_calculator'
require_relative 'weekly_date_calculator'
require_relative 'semi_monthly_date_calculator'
require_relative 'monthly_date_calculator'

class DateCalculatorFactory
  def self.get_calculator(interval)
    case interval
    when :daily
      DailyDateCalculator.new
    when :weekly
      WeeklyDateCalculator.new
    when :bi_weekly
      WeeklyDateCalculator.new(2)
    when :semi_monthly
      SemiMonthlyDateCalculator.new
    when :monthly
      MonthlyDateCalculator.new
    else
      raise "Invalid Interval. Please use :daily, :weekly, :bi_weekly, :semi_monthly or :monthly"
    end
  end
end