class HolidayFileParser
  def parse_file(file_path)
    results = Array.new
    File.open(file_path) do |file|
      file.each_line do |line|
        results << Date.strptime(line, "%m/%d/%Y")
      end
    end
    results
  end
end