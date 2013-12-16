require 'date_calculator'

class MonthlyDateCalculator < DateCalculator
  def get_all_paydates(start_date, end_date)
    #end the range here instead of end_date so that any payday failling between end_date and this will be included, which will then get paid inside start_date...end_date
    first_valid_payday_outside_range = get_next_valid_paydate(end_date)

    result = (start_date...first_valid_payday_outside_range).to_a.select! {|day| is_corresponding_paydate?(start_date, day)}
    result.map! {|day| get_last_valid_paydate(day)}
    result.keep_if {|day| (start_date...end_date).cover?(day) }
  end

  private
  def is_corresponding_paydate?(start_date, day)
    month_ctr = 12*(day.year - start_date.year) + day.month - start_date.month 
    day.day == (start_date >> month_ctr).day
  end
end