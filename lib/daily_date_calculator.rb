require_relative 'date_calculator'

class DailyDateCalculator < DateCalculator
  def get_all_paydates(start_date, end_date)
    (start_date...end_date).to_a.keep_if {|day| valid_paydate?(day)}
  end
end