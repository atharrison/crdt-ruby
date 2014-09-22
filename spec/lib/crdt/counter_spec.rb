require_relative '../../spec_helper'

describe CRDT::Counter do

  context "increment base case" do
    it "can increment to 3" do
      counter = CRDT::Counter.new
      time = 1
      counter.inc('name',time)
      counter.inc('name',time+=1)
      counter.inc('name',time+=1)
      expect(counter.value).to eq 3
    end
  end

  context "multiple messages" do
    it "can increment to 3" do
      counter = CRDT::Counter.new
      time1 = 1
      time2 = 2
      counter.inc('name',time1)
      counter.inc('name',time2)
      counter.inc('name',time2)
      expect(counter.value).to eq 2
    end
  end

  context "decrement base case" do
    it "can increment to 3 and then decrement to 1" do
      counter = CRDT::Counter.new
      counter.inc('name',1)
      counter.inc('name',2)
      counter.inc('name',3)
      expect(counter.value).to eq 3
      counter.dec('name', 4)
      counter.dec('name', 5)
      expect(counter.value).to eq 1
    end
  end

  context "multiple messages" do
    it "can increment to 3 and then decrement to 1" do
      counter = CRDT::Counter.new
      counter.inc('name',1)
      counter.inc('name',2)
      counter.inc('name',3)
      counter.inc('name',3)
      counter.inc('name',3)
      expect(counter.value).to eq 3
      counter.dec('name', 4)
      counter.dec('name', 4)
      counter.dec('name', 5)
      counter.dec('name', 5)
      expect(counter.value).to eq 1
    end
  end
end
