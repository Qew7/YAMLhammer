require 'yaml'

class MoralePhase
  def initialize(battlefield_file)
    @battlefield_file = battlefield_file
    @battlefield = YAML.load_file(battlefield_file)
  end

  def execute
    puts "  Executing Morale Phase"
    puts "      Leadership tests are taken."
    save_battlefield
  end

  def save_battlefield
    File.open(@battlefield_file, 'w') { |file| file.write(@battlefield.to_yaml) }
  end
end

if ARGV.length != 1
  puts "Usage: ruby phases/morale_phase.rb <battlefield_file>"
  exit 1
end

morale_phase = MoralePhase.new(ARGV[0])
morale_phase.execute
