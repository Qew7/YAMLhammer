require 'yaml'

class MagicPhase
  def initialize(battlefield_file)
    @battlefield_file = battlefield_file
    @battlefield = YAML.load_file(battlefield_file)
  end

  def execute
    puts "  Executing Magic Phase"
    puts "      Magic is cast and dispelled."
    save_battlefield
  end

  def save_battlefield
    File.open(@battlefield_file, 'w') { |file| file.write(@battlefield.to_yaml) }
  end
end

if ARGV.length != 1
  puts "Usage: ruby phases/magic_phase.rb <battlefield_file>"
  exit 1
end

magic_phase = MagicPhase.new(ARGV[0])
magic_phase.execute
