require_relative '../../models/coordinate.rb'

RSpec.describe Coordinate, type: :model do
  subject(:coordinate) { Coordinate.new }

  context '#initialize' do
    it 'creates a coordinate when given no parameters' do
      coordinate = Coordinate.new()
      expect(coordinate).to have_attributes(
        :x => 0,
        :y => 0
      )
    end

    it 'creates a coordinate when given valid parameters' do
      coordinate = Coordinate.new( x: 1, y: 1 )
      expect(coordinate).to have_attributes(
        :x => 1,
        :y => 1
      )
    end

    it 'raises an error when given invalid parameters' do
      expect{ Coordinate.new( x: 'fun', y: 1 ) }.to raise_error(RuntimeError)
    end
  end

  context '#valid?' do
    it 'returns true if @valid is true' do
      subject.instance_variable_set('@valid', true)
      expect(subject.valid?).to be(true)
    end

    it 'calls #validate if @valid is false' do
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

  context '#validate' do
    context 'without @@max_coords set' do
      # NOTE using mathematical point notation for ease
      it 'returns true if (x,y) is Integer and >= 0' do
        subject.x = 0
        subject.y = 0
        expect( subject.send(:validate) ).to be(true)
      end

      it 'returns false if x not an Integer' do
        subject.x = nil
        expect( subject.send(:validate) ).to be(false)
      end

      it 'returns false if y not an Integer' do
        subject.y = nil
        expect( subject.send(:validate) ).to be(false)
      end

      it 'returns false if x < 0' do
        subject.x = -1
        expect( subject.send(:validate) ).to be(false)
      end

      it 'returns false if y < 0' do
        subject.x = -1
        expect( subject.send(:validate) ).to be(false)
      end
    end

    context 'with @@max_coords set' do
      before do
        Coordinate.new({ x: 5, y: 5 }, true)
      end

      it 'returns true if (x,y) is Integer and >= 0 and <= @@max_coords(x,y)' do
        subject.x = 2
        subject.y = 4
        expect( subject.send(:validate) ).to be(true)
      end

      it 'returns false if x > @@max_coords.x' do
        subject.x = Coordinate.max_coords.x + 1
        expect( subject.send(:validate) ).to be(false)
      end

      it 'returns false if y > @@max_coords.y' do
        subject.x = Coordinate.max_coords.y + 1
        expect( subject.send(:validate) ).to be(false)
      end
    end

  end
end
