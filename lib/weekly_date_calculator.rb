require_relative 'date_calculator'

class WeeklyDateCalculator < DateCalculator
  attr_reader :n_weekly

  def initialize(n_weekly = 1)
    raise "n_weekly should be a positive integer" if !n_weekly.is_a?(Integer) || n_weekly < 1
    @n_weekly = n_weekly
  end

  def get_all_paydates(start_date, end_date)
    all_days = (start_date...end_date).to_a.select!{|day| day.wday == 5}
    
    if is_weekend?(start_date)
      all_days.select.each_with_index { |day, i| (i+1) % @n_weekly == 0 }
    else
      all_days.select.each_with_index { |day, i| i % @n_weekly == 0 }
    end
  end
end