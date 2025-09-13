require 'yaml'
require_relative 'phase_manager'

class MovementPhase
  include PhaseManager

  def initialize(battlefield_file_path)
    initialize_phase_data(battlefield_file_path)
  end

  def execute
    puts "  Executing Movement Phase"
    puts "      Units are moved."

    set_next_phase # Call the new method from PhaseManager

    save_battlefield
  end
end

if ARGV.length != 1
  puts "Usage: ruby phases/movement_phase.rb <battlefield_file_path>"
  exit 1
end

movement_phase = MovementPhase.new(ARGV[0])
movement_phase.execute
