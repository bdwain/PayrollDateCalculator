require 'date'

class DateCalculator
  def initialize(date, interval)
    begin
      @begin_date = Date.strptime(date, "%D")
    rescue ArgumentError
      raise "Invalid Date. Use form MM/DD/YYYY"
    end

    case interval
    when "daily"
      @interval = :daily
    when "weekly"
      @interval = :weekly
    when "bi-weekly"
      @interval = :bi_weekly
    when "semi-monthly"
      @interval = :semi_monthly
    when "monthly"
      @interval = :monthly
    else
      raise "Invalid Interval. Please use daily, weekly, bi-weekly, semi-monthly or monthly"
    end
  end
end