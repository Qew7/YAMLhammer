require 'yaml'

class Game
  attr_accessor :battlefield, :rules

  def initialize(battlefield_file, rules_file)
    @battlefield = YAML.load_file(battlefield_file)
    @rules = YAML.load_file(rules_file)
    @battlefield_file = battlefield_file
  end

  def run_turn
    current_player_name = @battlefield['current_turn']['player']
    puts "Starting turn for #{current_player_name}"

    @rules['phases'].each do |phase|
      puts "  Executing #{phase['name']}"
      execute_phase(phase)
    end

    update_turn_data
    save_battlefield
    puts "Turn for #{current_player_name} completed. Next player: #{@battlefield['current_turn']['player']}"
  end

  def execute_phase(phase)
    case phase['name']
    when 'Movement Phase'
      handle_movement_phase
    when 'Magic Phase'
      handle_magic_phase
    when 'Shooting Phase'
      handle_shooting_phase
    when 'Combat Phase'
      handle_combat_phase
    when 'Morale Phase'
      handle_morale_phase
    else
      puts "    No specific handler for #{phase['name']}"
    end
  end

  def handle_movement_phase
    # Simple movement: units just "move" without changing actual position in this prototype
    @battlefield['armies'].each do |army_name, units|
      units.each do |unit|
        puts "      #{unit['name']} in #{army_name} moves."
      end
    end
  end

  def handle_magic_phase
    puts "      Magic is cast and dispelled."
  end

  def handle_shooting_phase
    current_player_name = @battlefield['current_turn']['player']
    current_player_army_name = @battlefield['players'].find { |p| p['name'] == current_player_name }['army']
    opponent_army_name = @battlefield['players'].find { |p| p['name'] != current_player_name }['army']
    
    @battlefield['armies'][current_player_army_name].each do |attacking_unit|
      if attacking_unit['name'].include?('State Troops') # Example: only Empire State Troops shoot for now
        puts "      #{attacking_unit['name']} attempts to shoot."
        
        # Target a random unit from the opponent
        target_unit = @battlefield['armies'][opponent_army_name].sample
        
        if target_unit
          puts "        Targeting #{target_unit['name']}."
          
          # Simple hit/wound roll simulation
          hits = 0
          attacking_unit['models_count'].times do
            if rand(1..6) >= (4 - (attacking_unit['stats']['BS'] - 3)).clamp(2,6) # BS 3 needs 4+, BS 4 needs 3+ etc.
              hits += 1
            end
          end
          
          wounds = 0
          hits.times do
            # Simple wound calculation: S vs T
            if attacking_unit['stats']['S'] > target_unit['stats']['T']
              if rand(1..6) >= 3 # S > T, wound on 3+
                wounds += 1
              end
            elsif attacking_unit['stats']['S'] == target_unit['stats']['T']
              if rand(1..6) >= 4 # S == T, wound on 4+
                wounds += 1
              end
            else # S < T
              if rand(1..6) >= 5 # S < T, wound on 5+
                wounds += 1
              end
            end
          end
          
          puts "        #{hits} hits, #{wounds} wounds."
          
          if wounds > 0
            # Apply wounds as casualties
            target_unit['current_state']['casualties'] ||= 0
            target_unit['current_state']['casualties'] += wounds
            target_unit['models_count'] -= wounds
            target_unit['models_count'] = [0, target_unit['models_count']].max
            puts "        #{wounds} casualties to #{target_unit['name']}. Remaining models: #{target_unit['models_count']}."
          end
        end
      end
    end
  end


  def handle_combat_phase
    puts "      Units engage in combat."
  end

  def handle_morale_phase
    puts "      Leadership tests are taken."
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
game.run_turn
