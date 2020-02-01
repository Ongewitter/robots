require_relative '../../models/rover.rb'

RSpec.describe Rover, type: :model do
  subject(:rover) { Rover.new }

  context "#initialize" do
    it "creates a rover when given no parameters" do
      rover = Rover.new
      expect(rover).to have_attributes(
        :orientation => 'N',
        :instructions => []
      )
    end

    it "creates a Coordinate for rover.coordinates when given no parameters" do
      rover = Rover.new
      expect(rover.coordinates).to have_attributes( x: 0, y: 0 )
    end

    it "creates a rover when given valid parameters" do
      rover = Rover.new(coordinates: { x: 1, y: 1 }, orientation: 'S', instructions: ['L','R','M'] )
      expect(rover).to have_attributes(
        :orientation => 'S',
        :instructions => ['L','R','M']
      )
    end

    it "creates a Coordinate for rover.coordinates when given valid parameters" do
      rover = Rover.new(coordinates: { x: 1, y: 1 }, orientation: 'S', instructions: ['L','R','M'] )
      expect(rover.coordinates).to have_attributes( x: 1, y: 1 )
    end

    it "raises an error when given invalid coordinates parameter" do
      expect{ Rover.new(coordinates: {x: "bleh", y: "blah" }) }.to raise_error(RuntimeError)
    end

    it "raises an error when given invalid orientation parameter" do
      expect{ Rover.new(orientation: "wrong") }.to raise_error(RuntimeError)
    end

    it "raises an error when given invalid instructions parameter" do
      expect{ Rover.new(instructions: ['funkytime'] ) }.to raise_error(RuntimeError)
    end

    # NOTE I would use FactoryBot.build() for this, but seems overkill for just one spec
    # it "calls #validate" do
    #   rover = instance_double("Rover")
    #   expect(rover).to receive(:validate)
    #   rover.new
    # end

    it "sets @valid to true when given valid parameters" do
      rover = Rover.new
      expect(rover.instance_variable_get(:@valid)).to be(true)
    end
  end

  context "#go" do
    let (:rover) { Rover.new }
    it "calls perform_instructions if instructions is valid" do
      rover.instructions = ['L']
      expect( rover ).to receive(:perform_instructions)
      rover.go
    end

    it "does nothing if instructions is nil?" do
      rover.instructions = nil
      expect( rover ).not_to receive(:perform_instructions)
      rover.go
    end

    it "does nothing if instructions is empty?" do
      rover.instructions = ""
      expect( rover ).not_to receive(:perform_instructions)
      rover.go
    end
  end

  context "#to_s" do
    it "returns the rover as a string" do
      expect(subject.to_s).to eq("0 0 N")
    end
  end

  context "#valid?" do
    it "returns true if @valid is true" do
      subject.instance_variable_set('@valid', true)
      expect(subject.valid?).to be(true)
    end

    it "calls #validate if @valid is false" do
      subject.instance_variable_set('@valid', false)
      expect(subject).to receive(:validate)
      subject.valid?
    end

    it 'returns false if @valid is nil and validate returns false' do
      expect(subject).to receive(:validate).and_return(false)
      subject.instance_variable_set('@valid', nil)
      expect(subject.valid?).to be(false)
    end

    it 'returns true if @valid is nil and validate returns true' do
      expect(subject).to receive(:validate).and_return(true)
      subject.instance_variable_set('@valid', nil)
      expect(subject.valid?).to be(true)
    end

    it 'sets @valid if @valid is nil' do
      expect(subject).to receive(:validate).and_return(false)
      subject.instance_variable_set('@valid', nil)
      subject.valid?
      expect(subject.instance_variable_get('@valid')).to be(false)
    end
  end

  context "#perform_instructions" do
    it "calls #move if instruction is M" do
      subject.instructions = ['M']
      expect(subject).to receive(:move)
      subject.go
    end

    it "calls #turn if instruction is L" do
      subject.instructions = ['L']
      expect(subject).to receive(:turn)
      subject.go
    end

    it "calls #turn if instruction is R" do
      subject.instructions = ['R']
      expect(subject).to receive(:turn)
      subject.go
    end

    it "does nothing if instruction is not one of L, R or M" do
      subject.instructions = ['X']
      expect(subject).not_to receive(:turn)
      expect(subject).not_to receive(:move)
      subject.go
    end
  end

  context "#move" do
    context " with Coordinate.max_coords set to {5, 5} and instructions to ['M']" do
      before do
        Coordinate.new({x: 5, y: 5}, true)
        subject.instructions = ['M']
      end

      it "increments coordinates.y by 1 if orientation N" do
        subject.orientation = 'N'
        subject.go
        expect(subject.coordinates.y).to eq(1)
      end
      it "increments coordinates.x by 1 if orientation E" do
        subject.orientation = 'E'
        subject.go
        expect(subject.coordinates.x).to eq(1)
      end
      it "decrements coordinates.y by 1 if orientation S" do
        subject.coordinates.y = 2
        subject.orientation = 'S'
        subject.go
        expect(subject.coordinates.y).to eq(1)
      end
      it "decrements coordinates.x by 1 if orientation W" do
        subject.coordinates.x = 2
        subject.orientation = 'W'
        subject.go
        expect(subject.coordinates.x).to eq(1)
      end
      it "does not increment coordinates.y if it is Coordinate.max_coords.y and orientation N" do
        subject.coordinates.y = Coordinate.max_coords.y
        subject.orientation = 'N'
        subject.go
        expect(subject.coordinates.y).to eq(Coordinate.max_coords.y)
      end
      it "does not increment coordinates.x if it is Coordinate.max_coords.x and orientation E" do
        subject.coordinates.x = Coordinate.max_coords.y
        subject.orientation = 'E'
        subject.go
        expect(subject.coordinates.x).to eq(Coordinate.max_coords.y)
      end
      it "does not decrement coordinates.y if it is 0 and orientation S" do
        subject.coordinates.y = 0
        subject.orientation = 'S'
        subject.go
        expect(subject.coordinates.y).to eq(0)
      end
      it "does not decrement coordinates.x if it is 0 and orientation W" do
        subject.coordinates.x = 0
        subject.orientation = 'W'
        subject.go
        expect(subject.coordinates.x).to eq(0)
      end
    end
  end

  context "#turn" do
    it "changes self.orientation depending on given parameter" do
      subject.orientation = 'N'
      subject.instructions = ['L']
      subject.go
      expect( subject.orientation ).to eq('W')
    end
    it "changes self.orientation to a value in ORIENTATIONS" do
      subject.orientation = 'N'
      subject.instructions = ['L']
      subject.go
      expect( Rover::ORIENTATIONS ).to include(subject.orientation)
    end
  end

  context "#validate" do
    # NOTE I would use FactoryBot.build(:coordinate) for this but whatevs
    # it "calls coordinates.valid?" do
    #   expect( double("Coordinate") ).to receive(:valid?)
    #   Rover.new
    # end

    it "returns true if coordinates_check, orientation_check and instructions_check are true" do
      expect( subject.send(:validate) ).to be(true)
    end

    it "returns false if coordinates_check is false" do
      subject.coordinates = nil
      expect( subject.send(:validate) ).to be(false)
    end

    it "returns false if orientation_check is false" do
      subject.orientation = "bad"
      expect( subject.send(:validate) ).to be(false)
    end

    it "returns false if instructions_check is false" do
      subject.instructions = ['invalid']
      expect( subject.send(:validate) ).to be(false)
    end
  end
end
