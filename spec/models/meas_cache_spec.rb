require 'spec_helper'

describe MeasType do
  before :each do
    @definition = {
      name: "test_spec",
      unit: "?",
      comm: {
        command: ['t'],
        response_size: 2,
        coefficient_linear: 1,
        coefficient_offset: 0,
        interval: 0.5
      }
    }
    @name = @definition[:name]

    n = MeasCache.find(name: @name).first
    n.delete if n
  end

  ## OHM has problems with serialization
  #it "store definition" do
  #  name = "test_spec"
  #  hash = {a: 1, b: 2}
  #
  #  n = MeasCache.find(name: name).first
  #  n.delete if n
  #
  #  m = MeasCache.new
  #  m.name = name
  #  m.definition = hash
  #  m.save
  #
  #  n = MeasCache.find(name: name).first
  #  n.definition.should == hash
  #  puts n.definition.inspect
  #end

  it "fetch and store test command 't'" do
    meas_cache_storage = MeasCacheStorage.new(@name, @definition)
    10.times do
      meas_cache_storage.fetch
    end

  end
end
