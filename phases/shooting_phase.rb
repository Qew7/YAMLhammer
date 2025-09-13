require 'yaml'
require_relative 'phase_manager'

class ShootingPhase
  include PhaseManager

  def initialize(battlefield_file_path, artifact_name = nil)
    initialize_phase_data(battlefield_file_path, artifact_name)
  end

  def execute
    puts "  Executing Shooting Phase"
    puts "      Shots are fired."

    set_next_phase # Call the new method from PhaseManager

    save_battlefield
  end
end

if ARGV.length < 1 || ARGV.length > 2
  puts "Usage: ruby phases/shooting_phase.rb <battlefield_file_path> [artifact_name]"
  exit 1
end

shooting_phase = ShootingPhase.new(ARGV[0], ARGV[1])
shooting_phase.execute
