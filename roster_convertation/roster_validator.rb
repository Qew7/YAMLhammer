require 'rexml/document'
require 'json'

class RosterValidator
  def validate(input_data, file_extension)
    result =  case file_extension
              when '.xml', '.ros', '.rosz'
                parse_xml_for_validation(input_data)
              when '.json'
                parse_json_for_validation(input_data)
              else
                raise ArgumentError, "Unsupported file type for validation: #{file_extension}"
              end
    raise ArgumentError, "Validation failed for roster" if result.empty?
  end

  private

  def parse_xml_for_validation(xml_data)
    document = REXML::Document.new(xml_data)
    root = document.root

    if root
      {
        "battleScribeVersion" => root.attributes["battleScribeVersion"],
        "generatedBy" => root.attributes["generatedBy"],
        "gameSystemName" => root.attributes["gameSystemName"],
        "gameSystemRevision" => root.attributes["gameSystemRevision"],
        "catalogueName" => root.elements["forces/force"]&.attributes["catalogueName"],
        "catalogueRevision" => root.elements["forces/force"]&.attributes["catalogueRevision"],
        "xmlns" => root.attributes["xmlns"]
      }
    else
      {}
    end
  end

  def parse_json_for_validation(json_data)
    data = JSON.parse(json_data)
    roster_info = data["roster"]

    if roster_info
      {
        "battleScribeVersion" => data["battleScribeVersion"],
        "generatedBy" => data["generatedBy"],
        "gameSystemName" => data["gameSystemName"],
        "gameSystemRevision" => data["gameSystemRevision"],
        "catalogueName" => roster_info["catalogueName"],
        "catalogueRevision" => roster_info["catalogueRevision"],
        "xmlns" => data["xmlns"]
      }
    else
      {}
    end
  rescue JSON::ParserError => e
    {}
  end
end
