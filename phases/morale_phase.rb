require 'yaml'
require_relative 'phase_manager'

class MoralePhase
  include PhaseManager

  def initialize(battlefield_file_path, artifact_name = nil)
    initialize_phase_data(battlefield_file_path, artifact_name)
  end

  def execute
    puts "  Executing Morale Phase"
    puts "      Morale is checked."

    set_next_phase # Call the new method from PhaseManager

    save_battlefield
  end
end

if ARGV.length < 1 || ARGV.length > 2
  puts "Usage: ruby phases/morale_phase.rb <battlefield_file_path> [artifact_name]"
  exit 1
end

morale_phase = MoralePhase.new(ARGV[0], ARGV[1])
morale_phase.execute
