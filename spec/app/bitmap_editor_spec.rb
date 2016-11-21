require "spec_helper"
require_relative '../../app/bitmap_editor'

def stub_input(input_array)
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
end
