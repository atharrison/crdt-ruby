require_relative '../spec_helper'

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

describe CRDT::LWWSet do

  context "insert base case" do
    it "contains what was inserted" do
      set = CRDT::LWWSet.new
      set.insert('A', 1, 'foo')
      set.insert('A', 2, 'bar')
      expect(set.values).to eq ['foo', 'bar']
    end

    it "contains what was inserted when same item inserted multiple times" do
      set = CRDT::LWWSet.new
      set.insert('A', 1, 'foo')
      set.insert('A', 2, 'foo')
      set.insert('A', 3, 'bar')
      expect(set.values).to eq ['foo', 'bar']
    end

  end

  context "delete base case" do
    it "does not contain item that was deleted after insertion" do
      set = CRDT::LWWSet.new
      set.insert('A', 1, 'foo')
      set.insert('B', 2, 'bar')
      set.delete('B', 2, 'bar')
      expect(set.values).to eq ['foo']
    end
  end

  context "multiple messages" do
    it "contains expected values on duplicate insertion" do
      set = CRDT::LWWSet.new
      set.insert('A', 1, 'foo')
      set.insert('A', 2, 'bar')
      set.insert('A', 2, 'bar')
      expect(set.values).to eq ['foo', 'bar']
    end


  end
end
