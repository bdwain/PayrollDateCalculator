require 'date'

class DateCalculator
  def initialize(interval)
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

  def get_all_paydates(start_date, end_date)
    if !start_date.is_a?(Date) || !end_date.is_a?(Date)
      raise "Please pass in a 2 valid Dates"
    end

    first_valid_payday_outside_range = get_next_valid_paydate(end_date)
    case @interval
    when :daily
      (start_date...end_date).to_a.keep_if {|day| valid_paydate?(day)}
    
    when :weekly
      result = (start_date..first_valid_payday_outside_range).step(7).to_a
      result.map! {|day| get_last_valid_paydate(day)}.keep_if{|day| (start_date...end_date).cover?(day)}
    
    when :bi_weekly
      result = (start_date..first_valid_payday_outside_range).step(14).to_a
      result.map! {|day| get_last_valid_paydate(day)}.keep_if{|day| (start_date...end_date).cover?(day)}
    
    when :semi_monthly #15th and last day of the month
      Array.new # for now
    
    when :monthly
      result = (start_date...first_valid_payday_outside_range).to_a.select! {|day| is_corresponding_monthly_paydate?(start_date, day)}
      result.map! {|day| get_last_valid_paydate(day)}
      result.keep_if {|day| (start_date...end_date).cover?(day) }
    end
  end

  private
  def valid_paydate?(date)
    date.wday !=0 && date.wday != 6
  end

  def get_last_valid_paydate(date)
    date = date.prev_day until valid_paydate?(date)
    date
  end

  def get_next_valid_paydate(date)
    date = date.next_day until valid_paydate?(date)
    date
  end

  def is_corresponding_monthly_paydate?(start_date, day)
    month_ctr = 12*(day.year - start_date.year) + day.month - start_date.month 
    day.day == (start_date >> month_ctr).day
  end
end