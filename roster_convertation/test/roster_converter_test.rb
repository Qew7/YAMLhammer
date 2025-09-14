require 'minitest/autorun'
require 'fileutils'
require 'yaml'
require 'json'
require_relative '../convert_roster'

class RosterConverterTest < Minitest::Test
  def setup
    @temp_output_dir = File.join(__dir__, "temp_output")
    FileUtils.mkdir_p(@temp_output_dir) unless File.exist?(@temp_output_dir)
  end

  def teardown
    FileUtils.rm_rf(@temp_output_dir) if File.exist?(@temp_output_dir)
  end

  def test_xml_ros_to_yaml_conversion
    input_file = File.join(__dir__, "fixtures", "empire.ros")
    output_file = File.join(@temp_output_dir, "empire.yml")
    expected_output_file = File.join(__dir__, "fixtures", "empire_roster.yml")

    yaml_output = RosterConverter.new(input_file).convert_to_yaml

    File.write(output_file, yaml_output)

    assert File.exist?(output_file)
    assert_equal YAML.load_file(expected_output_file), YAML.load_file(output_file)
  end

  def test_json_to_yaml_conversion
    input_file = File.join(__dir__, "fixtures", "empire.json")
    output_file = File.join(@temp_output_dir, "empire_json.yml")
    
    json_data = File.read(input_file)

    yaml_output_string = RosterConverter.new(input_file).convert_to_yaml
    actual_hash = YAML.load(yaml_output_string)

    expected_hash = JSON.parse(json_data)

    File.write(output_file, yaml_output_string)

    assert File.exist?(output_file)
    assert_equal expected_hash, actual_hash
  end

  def test_rosz_to_yaml_conversion
    input_file = File.join(__dir__, "fixtures", "empire.rosz")
    output_file = File.join(@temp_output_dir, "empire_rosz.yml")
    expected_output_file = File.join(__dir__, "fixtures", "empire_roster.yml")

    yaml_output = RosterConverter.new(input_file).convert_to_yaml

    File.write(output_file, yaml_output)

    assert File.exist?(output_file)
    assert_equal YAML.load_file(expected_output_file), YAML.load_file(output_file)
  end
end
