require 'yaml'
require_relative 'phase_manager'

class ShootingPhase
  include PhaseManager

  def initialize(battlefield_file)
    @battlefield_file = battlefield_file
    @battlefield = YAML.load_file(battlefield_file)
  end

  def execute
    puts "  Executing Shooting Phase"
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

    set_next_phase # Call the new method from PhaseManager

    save_battlefield
  end

  def save_battlefield
    File.open(@battlefield_file, 'w') { |file| file.write(@battlefield.to_yaml) }
  end
end

if ARGV.length != 1
  puts "Usage: ruby phases/shooting_phase.rb <battlefield_file>"
  exit 1
end

shooting_phase = ShootingPhase.new(ARGV[0])
shooting_phase.execute
