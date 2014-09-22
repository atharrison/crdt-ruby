require_relative '../../spec_helper'

describe CRDT::RoshiSet do

  context "insert base case" do
    it "contains what was inserted" do
      set = CRDT::RoshiSet.new
      set.insert('A', 1, 'foo')
      set.insert('B', 2, 'bar')
      expect(set.values).to eq ['foo', 'bar']
    end

    it "contains what was inserted when same item inserted multiple times" do
      set = CRDT::RoshiSet.new
      set.insert('A', 1, 'foo')
      set.insert('A', 2, 'foo')
      set.insert('B', 3, 'bar')
      expect(set.values).to eq ['foo', 'bar']
    end

  end

  context "delete base case" do
    it "does not contain item that was deleted after insertion" do
      set = CRDT::RoshiSet.new
      set.insert('A', 1, 'foo')
      set.insert('B', 2, 'bar')
      set.delete('B', 3, 'bar')
      expect(set.values).to eq ['foo']
    end
  end

  context "multiple messages" do
    it "contains expected values on duplicate insertion" do
      set = CRDT::RoshiSet.new
      set.insert('A', 1, 'foo')
      set.insert('B', 2, 'bar')
      set.insert('B', 2, 'bar')
      expect(set.values).to eq ['foo', 'bar']
    end


  end
end
