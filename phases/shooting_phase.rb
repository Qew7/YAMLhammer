require 'yaml'
require_relative 'phase_manager'

class ShootingPhase
  include PhaseManager

  def initialize(battlefield_file_path)
    initialize_phase_data(battlefield_file_path)
  end

  def execute
    puts "  Executing Shooting Phase"
    puts "      Shots are fired."


    save_battlefield
  end
end

if ARGV.length != 1
  puts "Usage: ruby phases/shooting_phase.rb <battlefield_file_path>"
  exit 1
end

shooting_phase = ShootingPhase.new(ARGV[0])
shooting_phase.execute
