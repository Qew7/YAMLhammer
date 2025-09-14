#!/usr/bin/env ruby

require_relative 'convert_roster'

if __FILE__ == $PROGRAM_NAME
  if ARGV.length != 2
    puts "Usage: ruby #{$PROGRAM_NAME} <input_file> <output_yml_file>"
    exit 1
  end

  input_file = ARGV[0]
  output_file = ARGV[1]

  begin
    roster_converter = RosterConverter.new(input_file)
    yaml_output = roster_converter.convert_to_yaml
    File.write(output_file, yaml_output)
    puts "Successfully converted '#{input_file}' to '#{output_file}'."
  rescue ArgumentError => e
    puts e.message
    exit 1
  rescue StandardError => e
    puts "An unexpected error occurred: #{e.message}"
    exit 1
  end
end
