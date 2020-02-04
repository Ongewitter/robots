require_relative '../../models/rover.rb'

RSpec.describe Rover, type: :model do
  subject(:rover) { Rover.new }

  context '#initialize' do
    it 'creates a rover when given no parameters' do
      expect(subject).to have_attributes(
        orientation: 'N',
        instructions: []
      )
    end

    it 'creates a Coordinate for rover.coordinates when given no parameters' do
      expect(subject.coordinates).to have_attributes( x: 0, y: 0 )
    end

    it 'creates a rover when given valid parameters' do
      rover = Rover.new(coordinates: { x: 1, y: 1 }, orientation: 'S', instructions: ['L','R','M'] )
      expect(rover).to have_attributes(
        orientation: 'S',
        instructions: ['L','R','M']
      )
    end

    it 'creates a Coordinate for rover.coordinates when given valid parameters' do
      rover = Rover.new(coordinates: { x: 1, y: 1 }, orientation: 'S', instructions: ['L','R','M'] )
      expect(rover.coordinates).to have_attributes( x: 1, y: 1 )
    end

    it 'raises an error when given invalid coordinates parameter' do
      expect{ Rover.new(coordinates: {x: 'bleh', y: 'blah' }) }.to raise_error(RuntimeError)
    end

    it 'raises an error when given invalid orientation parameter' do
      expect{ Rover.new(orientation: 'wrong') }.to raise_error(RuntimeError)
    end

    it 'raises an error when given invalid instructions parameter' do
      expect{ Rover.new(instructions: ['funkytime'] ) }.to raise_error(RuntimeError)
    end
  end

  context '#go' do
    it 'calls perform_instructions if instructions is valid' do
      subject.instructions = ['L']
      expect( subject ).to receive(:perform_instructions)
      subject.go
    end

    it 'calls #move if instruction is M' do
      subject.instructions = ['M']
      expect(subject).to receive(:move)
      subject.go
    end

    it 'calls #turn if instruction is L' do
      subject.instructions = ['L']
      expect(subject).to receive(:turn)
      subject.go
    end

    it 'calls #turn if instruction is R' do
      subject.instructions = ['R']
      expect(subject).to receive(:turn)
      subject.go
    end

    # NOTE: Conscious choice to just let the rover idle instead of throwing an error
    it 'does nothing if instructions is nil?' do
      subject.instructions = nil
      expect( subject ).not_to receive(:perform_instructions)
      subject.go
    end

    it 'does nothing if instructions is empty?' do
      subject.instructions = ''
      expect( subject ).not_to receive(:perform_instructions)
      subject.go
    end

    it 'does nothing if instruction is not one of L, R or M' do
      subject.instructions = ['X']
      expect(subject).not_to receive(:turn)
      expect(subject).not_to receive(:move)
      subject.go
    end

    context 'with instruction that calls #move' do
      context 'with Coordinate.max_coords set to {5, 5} and instructions to ["M"]' do
        before do
          Coordinate.new({x: 5, y: 5}, true)
          subject.instructions = ['M']
        end

        it 'increments coordinates.y by 1 if orientation N' do
          subject.orientation = 'N'
          subject.go
          expect(subject.coordinates.y).to eq(1)
        end
        it 'increments coordinates.x by 1 if orientation E' do
          subject.orientation = 'E'
          subject.go
          expect(subject.coordinates.x).to eq(1)
        end
        it 'decrements coordinates.y by 1 if orientation S' do
          subject.coordinates.y = 2
          subject.orientation = 'S'
          subject.go
          expect(subject.coordinates.y).to eq(1)
        end
        it 'decrements coordinates.x by 1 if orientation W' do
          subject.coordinates.x = 2
          subject.orientation = 'W'
          subject.go
          expect(subject.coordinates.x).to eq(1)
        end
        it 'does not increment coordinates.y if it is Coordinate.max_coords.y and orientation N' do
          subject.coordinates.y = Coordinate.max_coords.y
          subject.orientation = 'N'
          subject.go
          expect(subject.coordinates.y).to eq(Coordinate.max_coords.y)
        end
        it 'does not increment coordinates.x if it is Coordinate.max_coords.x and orientation E' do
          subject.coordinates.x = Coordinate.max_coords.x
          subject.orientation = 'E'
          subject.go
          expect(subject.coordinates.x).to eq(Coordinate.max_coords.x)
        end
        it 'does not decrement coordinates.y if it is 0 and orientation S' do
          subject.coordinates.y = 0
          subject.orientation = 'S'
          subject.go
          expect(subject.coordinates.y).to eq(0)
        end
        it 'does not decrement coordinates.x if it is 0 and orientation W' do
          subject.coordinates.x = 0
          subject.orientation = 'W'
          subject.go
          expect(subject.coordinates.x).to eq(0)
        end
      end
    end

    context 'with instruction that calls #turn' do
      context 'with orientation N' do
        it 'changes to W when instruction is L' do
          subject.orientation = 'N'
          subject.instructions = ['L']
          subject.go
          expect( subject.orientation ).to eq('W')
        end

        it 'changes to E when instruction is R' do
          subject.orientation = 'N'
          subject.instructions = ['R']
          subject.go
          expect( subject.orientation ).to eq('E')
        end

        it 'changes self.orientation to a value in ORIENTATIONS' do
          subject.orientation = 'N'
          subject.instructions = ['L']
          subject.go
          expect( Rover::ORIENTATIONS ).to include(subject.orientation)
        end
      end

      context 'with orientation E' do
        it 'changes to N when instruction is L' do
          subject.orientation = 'E'
          subject.instructions = ['L']
          subject.go
          expect( subject.orientation ).to eq('N')
        end

        it 'changes to S when instruction is R' do
          subject.orientation = 'E'
          subject.instructions = ['R']
          subject.go
          expect( subject.orientation ).to eq('S')
        end

        it 'changes self.orientation to a value in ORIENTATIONS' do
          subject.orientation = 'E'
          subject.instructions = ['L']
          subject.go
          expect( Rover::ORIENTATIONS ).to include(subject.orientation)
        end
      end

      context 'with orientation S' do
        it 'changes to E when instruction is L' do
          subject.orientation = 'S'
          subject.instructions = ['L']
          subject.go
          expect( subject.orientation ).to eq('E')
        end

        it 'changes to W when instruction is R' do
          subject.orientation = 'S'
          subject.instructions = ['R']
          subject.go
          expect( subject.orientation ).to eq('W')
        end

        it 'changes self.orientation to a value in ORIENTATIONS' do
          subject.orientation = 'S'
          subject.instructions = ['L']
          subject.go
          expect( Rover::ORIENTATIONS ).to include(subject.orientation)
        end
      end

      context 'with orientation W' do
        it 'changes to S when instruction is L' do
          subject.orientation = 'W'
          subject.instructions = ['L']
          subject.go
          expect( subject.orientation ).to eq('S')
        end

        it 'changes to N when instruction is R' do
          subject.orientation = 'W'
          subject.instructions = ['R']
          subject.go
          expect( subject.orientation ).to eq('N')
        end

        it 'changes self.orientation to a value in ORIENTATIONS' do
          subject.orientation = 'W'
          subject.instructions = ['L']
          subject.go
          expect( Rover::ORIENTATIONS ).to include(subject.orientation)
        end
      end
    end
  end

  context '#to_s' do
    it 'returns the rover as a string' do
      expect(subject.to_s).to eq('0 0 N')
    end
  end

  context '#valid?' do
    it 'calls #validate' do
      expect( subject ).to receive(:validate)
      subject.valid?
    end

    it 'returns true if coordinates, orientation and instructions are valid' do
      expect( subject.valid? ).to be(true)
    end

    it 'returns false if coordinates is invalid' do
      subject.coordinates = nil
      expect( subject.valid? ).to be(false)
    end

    it 'returns false if orientation is invalid' do
      subject.orientation = 'bad'
      expect( subject.valid? ).to be(false)
    end

    it 'returns false if instructions is invalid' do
      subject.instructions = ['invalid']
      expect( subject.valid? ).to be(false)
    end
  end
end
