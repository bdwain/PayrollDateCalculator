require 'date'

class DateCalculator
  def initialize(date, interval)
    begin
      @begin_date = Date.strptime(date, "%D")
    rescue ArgumentError
      raise "Invalid Date. Use form MM/DD/YYYY"
    end
  end
end