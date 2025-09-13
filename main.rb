require 'yaml'

class Game
  attr_accessor :battlefield, :rules

  def initialize(battlefield_file, rules_file)
    @battlefield = YAML.load_file(battlefield_file)
    @rules = YAML.load_file(rules_file)
    @battlefield_file = battlefield_file
  end

  def update_turn_data
    current_player_name = @battlefield['current_turn']['player']
    players = @battlefield['players'].map { |p| p['name'] }
    current_player_index = players.index(current_player_name)
    next_player_index = (current_player_index + 1) % players.length

    @battlefield['current_turn']['player'] = players[next_player_index]
    if next_player_index == 0 # If it's back to the first player, increment turn number
      @battlefield['current_turn']['turn_number'] += 1
    end
    @battlefield['current_turn']['phase'] = @rules['phases'].first['name'] # Reset phase to first phase
  end

  def save_battlefield
    File.open(@battlefield_file, 'w') { |file| file.write(@battlefield.to_yaml) }
  end
end

if ARGV.length != 2
  puts "Usage: ruby main.rb <battlefield_file> <rules_file>"
  exit 1
end

battlefield_file = ARGV[0]
rules_file = ARGV[1]

game = Game.new(battlefield_file, rules_file)
game.update_turn_data
game.save_battlefield
