require "spec_helper"
require_relative '../../app/bitmap_editor'

def stub_input(input_array)
  # always exit at the end of the test
  input_array << "X"
  allow($stdin).to receive(:gets) {
    response = input_array[@input_counter]
    @input_counter += 1
    response
  }
end

describe 'BitmapEditor' do

  before :each do
    $stdin = StringIO.new
    $stdout = StringIO.new
    @input_counter = 0
    @be = BitmapEditor.new
    @dimension_error = "ERROR: each dimension of the image must be between 1 and 250"
    @coordinate_range_error = "ERROR: coordinates out of range"
  end

  after :each do
    $stdin = STDIN
    $stdout = STDOUT
  end

  it "exits when 'X' is entered" do
    stub_input(["X"])
    @be.run
    expect(@be.instance_variable_get(:@running)).to eq false
    expect($stdout.string).to include "goodbye!"
  end

  it "shows help when '?' is entered" do
    stub_input(["?"])
    @be.run
    expect($stdout.string).to include "I M N - Create a new M x N image with all pixels coloured white (O)."
  end

  it "displays message for unrecognised input" do
    stub_input(["blah"])
    @be.run
    expect($stdout.string).to include "unrecognised command :("
  end

  it "can make a face" do
    stub_input(["I 5 5", "L 2 1 X", "L 4 1 X", "L 3 3 X", "L 1 4 X", "L 5 4 X", "H 2 4 5 X"])
    @be.run
    expected = [
      ["0","X","0","X","0"],
      ["0","0","0","0","0"],
      ["0","0","X","0","0"],
      ["X","0","0","0","X"],
      ["0","X","X","X","0"]
    ]
    expect(@be.instance_variable_get(:@image)).to eq expected
  end

  describe "'S'" do
    it "return 'no image' if image hasn't been initialised" do
      stub_input(["S"])
      @be.run
      expect($stdout.string).to include "no image"
    end

    it "returns the stored image" do
      stub_input(["I 3 2","S"])
      @be.run
      expect($stdout.string).to include "000\n000"
    end
  end

  describe "'I M N'" do
    it "sets image instance variable to MxN array of white pixels" do
      stub_input(["I 3 2"])
      @be.run
      expect(@be.instance_variable_get(:@image)).to eq([["0","0","0"],["0","0","0"]])
    end

    it "returns error message if M is less than 1" do
      stub_input(["I 0 2"])
      @be.run
      expect($stdout.string).to include @dimension_error
    end

    it "returns error message if M is more than 250" do
      stub_input(["I 251 2"])
      @be.run
      expect($stdout.string).to include @dimension_error
    end

    it "returns error message if N is less than 1" do
      stub_input(["I 2 0"])
      @be.run
      expect($stdout.string).to include @dimension_error
    end

    it "returns error message if M is more than 250" do
      stub_input(["I 2 251"])
      @be.run
      expect($stdout.string).to include @dimension_error
    end

    it "returns error message if dimension is invalid type" do
      stub_input(["I I 2"])
      @be.run
      expect($stdout.string).to include @dimension_error
    end
  end

  describe "'L X Y C'" do
    it "colours the pixel (X,Y) with colour C" do
      stub_input(["I 3 3","L 2 3 A"])
      @be.run
      expect(@be.instance_variable_get(:@image)).to eq([["0","0","0"],["0","0","0"],["0","A","0"]])
    end

    it "returns error message if colour is not a capital letter" do
      stub_input(["I 3 3","L 2 2 a"])
      @be.run
      expect($stdout.string).to include "ERROR: colour must be a capital letter"
    end

    it "returns error message if colour is not a single letter" do
      stub_input(["I 3 3","L 2 2 ABC"])
      @be.run
      expect($stdout.string).to include "ERROR: colour must be a capital letter"
    end

    it "returns error message if a dimension is invalid" do
      stub_input(["I 2 2", "L 0 2"])
      @be.run
      expect($stdout.string).to include @dimension_error
    end
  end

  describe "'V X Y1 Y2 C'" do
    it "draws vertical segment of colour C in column X between rows Y1 and Y2" do
      stub_input(["I 3 3", "V 1 1 3 B"])
      @be.run
      expect(@be.instance_variable_get(:@image)).to eq([["B","0","0"],["B","0","0"],["B","0","0"]])
    end

    it "returns error message if coordinates are out of range" do
      stub_input(["I 3 3", "V 4 1 3 B"])
      @be.run
      expect(@be.instance_variable_get(:@image)).to eq([["0","0","0"],["0","0","0"],["0","0","0"]])
      expect($stdout.string).to include @coordinate_range_error
    end

    it "works when Y1 > Y2" do
      stub_input(["I 3 3", "V 1 3 1 B"])
      @be.run
      expect(@be.instance_variable_get(:@image)).to eq([["B","0","0"],["B","0","0"],["B","0","0"]])
    end
  end

  describe "'H X1 X2 Y C'" do
    it "draws horizontal segment of colour C in row Y between columns X1 and X2" do
      stub_input(["I 3 3", "H 1 2 2 B"])
      @be.run
      expect(@be.instance_variable_get(:@image)).to eq([["0","0","0"],["B","B","0"],["0","0","0"]])
    end

    it "returns error message if coordinates are out of range" do
      stub_input(["I 3 3", "H 4 1 3 B"])
      @be.run
      expect(@be.instance_variable_get(:@image)).to eq([["0","0","0"],["0","0","0"],["0","0","0"]])
      expect($stdout.string).to include @coordinate_range_error
    end

    it "works when X1 > X2" do
      stub_input(["I 3 3", "H 3 1 1 B"])
      @be.run
      expect(@be.instance_variable_get(:@image)).to eq([["B","B","B"],["0","0","0"],["0","0","0"]])
    end
  end

  describe "'C'" do
    it "clears all pixels to '0'" do
      stub_input(["I 3 3", "V 1 1 3 B", "C"])
      @be.run
      expect(@be.instance_variable_get(:@image)).to eq([["0","0","0"],["0","0","0"],["0","0","0"]])
    end
  end
end
