require_relative 'date_calculator'

class MonthlyDateCalculator < DateCalculator
  def get_all_paydates(start_date, end_date, holidays = [])
    @holidays = holidays
    get_all_paydates_on_days(start_date, end_date, [31])
  end

  protected
  #pays on the days in array valid_days, instead of the day of start_date
  def get_all_paydates_on_days(start_date, end_date, valid_days)
    #end the range here instead of end_date so that any payday failling between end_date and this will be included, which will then get paid inside start_date...end_date
    first_valid_payday_outside_range = get_next_valid_paydate(end_date)

    result = (start_date..first_valid_payday_outside_range).to_a.select! {|day| is_corresponding_paydate?(valid_days, day)}
    result.map! {|day| get_last_valid_paydate(day)}
    result.keep_if {|day| (start_date...end_date).cover?(day) }
  end

  private
  #returns true if day is on a valid_day or day is the last day of the month and there is a valid_day later than it (e.g valid_days = [31] && day is Feb. 28)
  def is_corresponding_paydate?(valid_days, day)
    valid_days.any? {|current_day| day.day == current_day || (day.next_day.month != day.month && day.day < current_day)}
  end
end