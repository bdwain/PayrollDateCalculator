require_relative 'lib/date_calculator_factory'

def parse_date_str(str)
  Date.strptime(str, "%m/%d/%Y")
end

if ARGV.include? "--help"
  puts "Usage: ruby main.rb <interval> <start_date> <end_date>"
  puts "  interval: can be any of daily, weekly, bi_weekly, semi_monthly, or monthly. defaults to bi_weekly"
  puts "     daily: pays every weekday"
  puts "     weekly: pays every friday, starting"
  puts "     bi_weekly: pays every other friday, starting with the first friday after start_date"
  puts "     semi_monthly: pays on the 15th and the last day of every month. if those days are on a weekend, it pays on the friday before"
  puts "     monthly: pays on the last day of every month. if those days are on a weekend, it pays on the friday before"
  puts "  start_date: the date to start calculating paydates from (MM/DD/YYYY). Defaults to today."
  puts "  end_date: the end date (not inclusive). Defaults to 1 year past start_date"
  exit
end

interval = (ARGV.length > 0 && ARGV[0].to_sym) || :bi_weekly
start_date = (ARGV.length > 1 && ARGV[1], "%m/%d/%Y")) || Date.today
end_date = (ARGV.length > 2 && Date.strptime(ARGV[2], "%m/%d/%Y")) || start_date >> 12

calc = DateCalculatorFactory.get_calculator(interval)

result = calc.get_all_paydates(start_date, end_date)

result.each do |date|
  puts date.strftime("%-m/%-d/%Y")
end