require 'date'

class DateCalculator
  def initialize(start_date, interval)
    if !start_date.is_a? Date
      raise "Please pass in a valid Date object"
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