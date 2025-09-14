require 'rexml/document'
require 'yaml'

class XmlToYamlConverter
  def convert(input_xml_data)
    document = REXML::Document.new(input_xml_data)
    converted_hash = xml_to_hash(document.root)
    converted_hash.to_yaml
  end

  private

  def xml_to_hash(element)
    hash = {}

    element.attributes.each do |key, value|
      hash[key] = value
    end

    element.elements.each do |child|
      child_hash = xml_to_hash(child)
      if hash.key?(child.name)
        if hash[child.name].is_a?(Array)
          hash[child.name] << child_hash
        else
          hash[child.name] = [hash[child.name], child_hash]
        end
      else
        hash[child.name] = child_hash
      end
    end

    if element.has_elements? == false && element.text && !element.text.strip.empty?
      hash['__content__'] = element.text.strip
    elsif element.has_elements? && element.text && !element.text.strip.empty?
      # If there's text content along with child elements, we might want to preserve it
      # This part needs careful consideration based on how important mixed content is.
      # For BattleScribe files, text often appears inside elements like <description>.
      hash['__content__'] = element.text.strip unless element.text.strip.empty?
    end

    hash
  end
end
