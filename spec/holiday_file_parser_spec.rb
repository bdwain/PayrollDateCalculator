require 'tempfile'
require 'date'
require 'holiday_file_parser'

describe HolidayFileParser do
  describe "#parse_file" do
    context "when the file exists" do
      context "when the file is well formatted" do
        it "returns an array of Dates from the contents of the file" do
          file_parser = HolidayFileParser.new
          file = Tempfile.new('HolidayFileParser_parse_file_test')
          begin
            file.puts("12/1/2013")
            file.puts("1/14/2014")
            file.rewind
            results = file_parser.parse_file(file.path)
          ensure
            file.close
            file.unlink
          end

          expect(results.length).to eq(2)
          expect(results.include?(Date.new(2013,12,1))).to be_true
          expect(results.include?(Date.new(2014,1,14))).to be_true
        end
      end

      context "when the file is not well formatted" do
        it "returns an array of Dates from the contents of the file" do
          file_parser = HolidayFileParser.new
          file = Tempfile.new('HolidayFileParser_parse_file_test')
          begin
            file.puts("bad format")
            file.rewind
            expect{file_parser.parse_file(file.path)}.to raise_error
          ensure
            file.close
            file.unlink
          end
        end
      end
    end
  end

  context "when the file does not exist" do
    it "raises the exception" do
      file_parser = HolidayFileParser.new
      expect {file_parser.parse_file("non_existant_file.bar")}.to raise_error
    end
  end
end