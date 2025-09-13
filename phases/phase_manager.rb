require 'yaml'

module PhaseManager
  def set_next_phase
    rules = YAML.load_file('rules/whfb6.yml') # Load rules directly here
    current_phase_name = @battlefield['current_turn']['phase']
    phases = rules['phases'].map { |p| p['name'] }
    current_phase_index = phases.index(current_phase_name)

    if current_phase_index && current_phase_index < phases.length - 1
      next_phase_name = phases[current_phase_index + 1]
      @battlefield['current_turn']['phase'] = next_phase_name
      puts "  Next phase set to: #{next_phase_name}"
    else
      puts "  No next phase explicitly set (handled by main.rb for turn advancement)."
    end
  end
end
