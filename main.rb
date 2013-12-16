require_relative 'lib/date_calculator_factory'
require_relative 'lib/holiday_file_parser'

def parse_date_str(str)
  Date.strptime(str, "%m/%d/%Y")
end

if ARGV.include? "help"
  puts "Usage: ruby main.rb <interval> <start_date> <end_date> <holiday_file>"
  puts "  interval: can be any of daily, weekly, bi_weekly, semi_monthly, or monthly. defaults to bi_weekly"
  puts "     daily: pays every weekday"
  puts "     weekly: pays every friday, starting"
  puts "     bi_weekly: pays every other friday, starting with the first friday after start_date"
  puts "     semi_monthly: pays on the 15th and the last day of every month. if those days are on a weekend, it pays on the friday before"
  puts "     monthly: pays on the last day of every month. if those days are on a weekend, it pays on the friday before"
  puts "  start_date: the date to start calculating paydates from (MM/DD/YYYY). Defaults to today."
  puts "  end_date: the end date (not inclusive). Defaults to 1 year past start_date"
  puts "  holiday_file: an optional text file containing a list of dates (formatted MM/DD/YYYY) on separate lines. These are invalid paydays, in addition to weekends"
  exit
end

interval = (ARGV[0] && ARGV[0].to_sym) || :bi_weekly

begin
  start_date = (ARGV[1] && parse_date_str(ARGV[1])) || Date.today
  end_date = (ARGV[2] && parse_date_str(ARGV[2])) || start_date >> 12
rescue ArgumentError
  puts "Invalid date passed. Please pass dates in the format MM/YY/DDDD. Run with parameter help for usage."
  exit
end

holiday_file = ARGV[3]
if holiday_file
  begin
    holidays = HolidayFileParser.new.parse_file(holiday_file)
  rescue Errno::ENOENT
    puts "The holiday file you specified does not exist. Run with parameter help for usage."
    exit
  rescue
    puts "The holiday file you specified is not well formatted. Run with parameter help for usage."
    exit
  end
else
  holidays = Array.new
end

begin
  calc = DateCalculatorFactory.get_calculator(interval)
rescue
  puts "Invalid interval. Please use daily, weekly, bi_weekly, semi_monthly, or monthly. Run with parameter help for usage."
  exit
end

result = calc.get_all_paydates(start_date, end_date, holidays)

result.each do |date|
  puts date.strftime("%-m/%-d/%Y")
end