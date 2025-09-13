require 'yaml'

class Game
  attr_accessor :battlefield, :rules

  include PhaseManager # Include PhaseManager for common methods

  def initialize(battlefield_file_path, rules_file_path, artifact_name = nil)
    @original_battlefield_file_path = battlefield_file_path
    @rules_file = rules_file_path
    @artifact_name = artifact_name
    @battlefield_file = find_battlefield_file # Use find_battlefield_file from PhaseManager
    @battlefield = YAML.load_file(@battlefield_file)
    @rules = YAML.load_file(@rules_file)
  end

  # Removed find_battlefield_file as it's now in PhaseManager

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

  def check_win_conditions
    max_rounds = @rules['win_conditions']['max_rounds']
    current_round = @battlefield['current_turn']['turn_number']

    if current_round > max_rounds
      puts "Battle ended: Maximum rounds (#{max_rounds}) reached!"
      @battlefield['current_turn']['phase'] = 'Game Over'
      @battlefield['winner'] = 'Draw (Max Rounds)'
      return
    end

    # Check for army annihilation
    @battlefield['armies'].each do |army_name, units|
      if units.all? { |unit| unit['models_count'] <= 0 }
        puts "Battle ended: #{army_name} army annihilated!"
        @battlefield['current_turn']['phase'] = 'Game Over'
        winning_player_name = @battlefield['players'].find { |p| p['army'] != army_name }['name']
        @battlefield['winner'] = winning_player_name
        return
      end
    end
  end

  # Removed save_battlefield as it's now in PhaseManager
end

if ARGV.length < 2 || ARGV.length > 3
  puts "Usage: ruby main.rb <battlefield_file_path> <rules_file_path> [artifact_name]"
  exit 1
end

battlefield_file = ARGV[0]
rules_file = ARGV[1]
artifact_name = ARGV[2]

game = Game.new(battlefield_file, rules_file, artifact_name)
game.update_turn_data
game.check_win_conditions
game.save_battlefield
