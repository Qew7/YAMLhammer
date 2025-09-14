require 'yaml'
require_relative 'phase_manager'

class MagicPhase
  include PhaseManager

  def initialize(battlefield_file_path)
    initialize_phase_data(battlefield_file_path)
  end

  def execute
    puts "  Executing Magic Phase"
    puts "      Magic is cast and dispelled."


    save_battlefield
  end
end

if ARGV.length != 1
  puts "Usage: ruby phases/magic_phase.rb <battlefield_file_path>"
  exit 1
end

magic_phase = MagicPhase.new(ARGV[0])
magic_phase.execute
