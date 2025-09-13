require 'yaml'
require_relative 'phase_manager'

class CombatPhase
  include PhaseManager

  def initialize(battlefield_file_path)
    initialize_phase_data(battlefield_file_path)
  end

  def execute
    puts "  Executing Combat Phase"
    puts "      Units engage in close quarters."

    set_next_phase # Call the new method from PhaseManager

    save_battlefield
  end
end

if ARGV.length != 1
  puts "Usage: ruby phases/combat_phase.rb <battlefield_file_path>"
  exit 1
end

combat_phase = CombatPhase.new(ARGV[0])
combat_phase.execute
