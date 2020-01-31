require_relative 'coordinate.rb'

class Rover
  # coordinates {x, y}
  # orientation

  ORIENTATIONS = ['N', 'E', 'S', 'W']
  TURNING = {'L' => -1, 'R' => 1}
  VALID_INSTRUCTIONS = ['L', 'R', 'M']

  def initialize(coordinates: { x: 0, y: 0 }, orientation: 'N', instructions: [])
    @coordinates = Coordinate.new(x: coordinates[:x], y: coordinates[:y])
    @orientation = orientation
    @instructions = instructions

    validate

    raise 'Rover is invalid' unless valid?
  end

  def go
    perform_instructions unless instructions.nil? || instructions.empty? # No Rails = no .blank?
  end

  def to_s
    "#{coordinates.x} #{coordinates.y} #{orientation}"
  end

  def valid?
    @valid ||= false
  end

  attr_accessor :coordinates, :orientation, :instructions

  private

  def perform_instructions
    instructions.each do |instruction|
      if instruction == 'M'
        move
      elsif TURNING.keys.include?(instruction)
        turn instruction
      end
    end
  end

  def move
    case orientation
    when 'N'
      coordinates.y = [coordinates.y + 1, $max_coords.y].min
    when 'E'
      coordinates.x = [coordinates.x + 1, $max_coords.x].min
    when 'S'
      coordinates.y = [coordinates.y - 1, 0].max
    when 'W'
      coordinates.x = [coordinates.x - 1, 0].max
    end
  end

  def turn(direction)
    orientation_id = ORIENTATIONS.index(orientation)
    self.orientation = ORIENTATIONS[(orientation_id + TURNING[direction]) % ORIENTATIONS.size]
  end

  def validate
    coordinates_check = !coordinates.nil? && coordinates.valid?
    orientation_check = ORIENTATIONS.include?(orientation)
    instructions_check = instructions.all? { |instruction| VALID_INSTRUCTIONS.include?(instruction) }

    @valid = coordinates_check && orientation_check && instructions_check
  end
end
