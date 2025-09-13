require 'yaml'

class MovementPhase
  def initialize(battlefield_file)
    @battlefield_file = battlefield_file
    @battlefield = YAML.load_file(battlefield_file)
  end

  def execute
    puts "  Executing Movement Phase"
    @battlefield['armies'].each do |army_name, units|
      units.each do |unit|
        puts "      #{unit['name']} in #{army_name} moves."
      end
    end
    save_battlefield
  end

  def save_battlefield
    File.open(@battlefield_file, 'w') { |file| file.write(@battlefield.to_yaml) }
  end
end

if ARGV.length != 1
  puts "Usage: ruby phases/movement_phase.rb <battlefield_file>"
  exit 1
end

movement_phase = MovementPhase.new(ARGV[0])
movement_phase.execute
