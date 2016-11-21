require_relative "../spec_helper"
require_relative "../../app/bitmap_editor"

def stub_input(input_array)
  input_array << "X"
  allow($stdin).to receive(:gets) {
    response = input_array[@input_counter]
    @input_counter += 1
    response
  }
end

describe BitmapEditor do
  before do
    $stdin = StringIO.new
    $stdout = StringIO.new
  end

  after do
    $stdin = STDIN
    $stdout = STDOUT
  end

  before :each do
    @input_counter = 0
    @be = BitmapEditor.new
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
end
