class Coordinate
  @@max_coords = nil

  def initialize(coordinates = { x: 0, y: 0 }, max_coords = false)
    @x = coordinates[:x]
    @y = coordinates[:y]

    raise 'Coordinate is invalid' unless valid?

    @@max_coords = self if max_coords
  end

  def valid?
    validate
  end

  def self.max_coords
    @@max_coords
  end

  attr_accessor :x, :y

  private

  def validate
    x_check = (@x.is_a? Integer) && @x >= 0
    y_check = (@y.is_a? Integer) && @y >= 0
    if @@max_coords
      x_check &&= @x <= @@max_coords.x
      y_check &&= @y <= @@max_coords.y
    end
    x_check && y_check
  end
end
