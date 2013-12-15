require 'date'

class DateCalculator
  def get_all_paydates(start_date, end_date)
    raise "Not implemented"    
  end

  protected
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
end