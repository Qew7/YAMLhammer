#!/usr/bin/env ruby

require_relative './xml_to_yaml_converter'
require_relative './json_to_yaml_converter'
require_relative './roster_validator'
require 'zip'
require 'fileutils'

class RosterConverter
  def initialize(input_file_path)
    @input_file_path = input_file_path
    @validator = RosterValidator.new
  end

  def convert_to_yaml
    unless File.exist?(@input_file_path)
      raise ArgumentError, "Error: Input file '#{@input_file_path}' not found."
    end

    file_extension = File.extname(@input_file_path).downcase
    input_data = File.read(@input_file_path)

    unless file_extension == '.rosz'
      @validator.validate(input_data, file_extension)
    end

    case file_extension
    when '.xml', '.ros'
      XmlToYamlConverter.new.convert(input_data)
    when '.json'
      JsonToYamlConverter.new.convert(input_data)
    when '.rosz'
      extract_and_convert_rosz(input_data)
    else
      raise ArgumentError, "Error: Unsupported file type '#{file_extension}'. Only .xml, .ros, .rosz, and .json are supported."
    end
  end

  private

  def extract_and_convert_rosz(rosz_data)
    temp_dir = Dir.mktmpdir
    begin
      temp_rosz_file_path = File.join(temp_dir, "temp.rosz")
      File.open(temp_rosz_file_path, 'wb') { |f| f.write(rosz_data) }

      Zip::File.open(temp_rosz_file_path) do |zip_file|
        ros_entry = zip_file.find { |entry| entry.name.downcase.end_with?('.ros') }

        raise ArgumentError, "No .ros file found inside '#{@input_file_path}'." unless ros_entry

        extracted_file_path = File.join(temp_dir, ros_entry.name)
        FileUtils.mkdir_p(File.dirname(extracted_file_path))

        File.open(extracted_file_path, 'wb') do |output_file|
          output_file.write(ros_entry.get_input_stream.read)
        end

        input_data = File.read(extracted_file_path)
        @validator.validate(input_data, '.ros')

        XmlToYamlConverter.new.convert(input_data)
      end
    ensure
      FileUtils.remove_entry(temp_dir)
    end
  end
end
