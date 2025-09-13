require 'yaml'

class CombatPhase
  def initialize(battlefield_file)
    @battlefield_file = battlefield_file
    @battlefield = YAML.load_file(battlefield_file)
  end

  def execute
    puts "  Executing Combat Phase"
    puts "      Units engage in combat."
    save_battlefield
  end

  def save_battlefield
    File.open(@battlefield_file, 'w') { |file| file.write(@battlefield.to_yaml) }
  end
end

if ARGV.length != 1
  puts "Usage: ruby phases/combat_phase.rb <battlefield_file>"
  exit 1
end

combat_phase = CombatPhase.new(ARGV[0])
combat_phase.execute
