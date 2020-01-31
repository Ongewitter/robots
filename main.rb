require_relative 'models/rover.rb'

$max_coords = nil

def execute
  begin
    max_grid
    puts '=====MARS=ROVER=TIME==='
    until @input == 'exit'
      create_rover
      move_rover
      report_rover
    end
  rescue => e
    p e.message
  end
end

def max_grid
  puts 'Type exit to quit'
  puts 'Please enter max grid size in format "X Y"'
  @input = gets.chomp.split(' ')
  $max_coords = Coordinate.new(x: @input[0].to_i, y: @input[1].to_i)
end

def create_rover
  puts 'Please enter new rover starting position and orientation'
  puts 'Format X Y Orientation'
  @input = gets.chomp.split(' ')
  input_coordinates = @input
  puts 'Please enter movement instructions'
  puts 'L = Turn left | R = Turn right | M = Move forward'
  @input = gets.chomp.split('')
  input_instructions = @input
  @rover = Rover.new(
    coordinates: { x: input_coordinates[0].to_i, y: input_coordinates[1].to_i },
    orientation: input_coordinates[2],
    instructions: input_instructions
  )
end

def move_rover
  @rover.go
end

def report_rover
  puts 'Rover position and orientation:'
  puts @rover.to_s
end

execute
