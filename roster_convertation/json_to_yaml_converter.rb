require 'json'
require 'yaml'

class JsonToYamlConverter
  def convert(input_json_data)
    hash = JSON.parse(input_json_data)
    hash.to_yaml
  end
end
