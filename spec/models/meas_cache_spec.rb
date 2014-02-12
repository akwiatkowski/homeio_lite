require 'spec_helper'

describe MeasType do
  before :each do
    @definition_test = {
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
    @name_test = @definition_test[:name]

    @definition_batt = {
      name: "batt_u_test",
      unit: "V",
      comm: {
        command: ['3'],
        response_size: 2,
        coefficient_linear: 0.0777126099706744868,
        coefficient_offset: 0,
        interval: 0.5
      }
    }
    @name_batt = @definition_batt[:name]

    n = MeasCache.find(name: @name_test).first
    n.delete if n
    n = MeasCache.find(name: @name_batt).first
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

  #it "fetch and store test command 't'" do
  #  meas_cache_storage = MeasCacheStorage.new(@name_test, @definition_test)
  #  2.times do
  #    meas_cache_storage.fetch
  #    #sleep 1
  #  end
  #
  #end

  it "fetch and store test command 't'" do
    meas_cache_storage = MeasCacheStorage.new(@name_batt, @definition_batt)
    2.times do
      meas_cache_storage.fetch
      #sleep 1
    end

  end
end
