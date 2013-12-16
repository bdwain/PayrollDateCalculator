PayrollDateCalculator
=====================

Calculates payroll dates between a start and end date using a specified pay interval.

### Usage

    ruby main.rb <interval> <start_date> <end_date> <holiday_file>

to get help at the command prompt

    ruby main.rb help


### Parameters
- interval: can be any of daily, weekly, bi_weekly, semi_monthly, or monthly. defaults to bi_weekly
- start_date: the date to start calculating paydates from (MM/DD/YYYY). Defaults to today.
- end_date: the end date (not inclusive). Defaults to 1 year past start_date
- holiday_file: an optional text file containing a list of dates (formatted MM/DD/YYYY) on separate lines. These are invalid paydays, in addition to weekends

### Intervals
- daily: pays every weekday
- weekly: pays every friday
- bi_weekly: pays every other friday, starting with the first friday after start_date
- semi_monthly: pays on the 15th and the last day of every month. if those days are on a weekend or holiday, it pays on the last valid day before it
- monthly: pays on the last day of every month. if those days are on a weekend, it pays on the last valid day before it

### Sample Output

    $ ruby main.rb semi_monthly 12/1/2013 6/1/2014

12/13/2013  
12/31/2013  
1/15/2014  
1/31/2014  
2/14/2014  
2/28/2014  
3/14/2014  
3/31/2014  
4/15/2014  
4/30/2014  
5/15/2014  
5/30/2014
    
    $ ruby main.rb weekly 12/1/2013 2/1/2014

12/6/2013  
12/13/2013  
12/20/2013  
12/27/2013  
1/3/2014  
1/10/2014  
1/17/2014  
1/24/2014  
1/31/2014

