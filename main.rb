require_relative 'models/rover.rb'

def execute
  begin
    puts 'Type exit to quit'
    max_grid
    puts '=====MARS=ROVER=TIME==='
    until @input == 'exit' # Whatever, I need a loop anyways
      create_rover
      move_rover
      report_rover
    end
  rescue => e
    p e.message
    raise
  end
end

def max_grid
  puts 'Please enter max grid size in format "X Y"'
  get_input
  coordinates = @input&.split(' ')
  Coordinate.new({x: coordinates[0].to_i, y: coordinates[1].to_i}, true) if coordinates
end

def create_rover
  puts 'Please enter new rover starting position and orientation'
  puts 'Format X Y Orientation'
  get_input
  input_coordinates = @input&.split(' ')
  puts 'Please enter movement instructions'
  puts 'L = Turn left | R = Turn right | M = Move forward'
  get_input
  input_instructions = @input&.split('')

  @rover = Rover.new(
    coordinates: { x: input_coordinates[0].to_i, y: input_coordinates[1].to_i },
    orientation: input_coordinates[2],
    instructions: input_instructions
  ) if input_coordinates && input_instructions
end

def move_rover
  @rover.go
end

def report_rover
  puts 'Rover position and orientation:'
  puts @rover.to_s
end

def get_input
  @input = gets&.chomp
  raise Interrupt if @input == 'exit' || @input.nil?
end

begin
  execute
rescue Interrupt
  puts "(ﾉಠдಠ)ﾉ︵┻━┻ Fine, get out!"
end
