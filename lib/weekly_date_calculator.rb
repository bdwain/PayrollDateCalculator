require 'date_calculator'

class WeeklyDateCalculator < DateCalculator
  attr_reader :n_weekly

  def initialize(n_weekly = 1)
    raise "n_weekly should be a positive integer" if !n_weekly.is_a?(Integer) || n_weekly < 1
    @n_weekly = n_weekly
  end

  def get_all_paydates(start_date, end_date)
    first_valid_payday_outside_range = get_next_valid_paydate(end_date)

    result = (start_date..first_valid_payday_outside_range).step(7*@n_weekly).to_a
    result.map! {|day| get_last_valid_paydate(day)}.keep_if{|day| (start_date...end_date).cover?(day)}
  end
end