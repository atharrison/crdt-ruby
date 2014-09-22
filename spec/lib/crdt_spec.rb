describe CRDT do

  context "class methods" do
    it "converts key, timestamp, value to expected entry" do
      expect(CRDT.entry_for('foo', 1, 'bar')).to eq(['foo',1,'bar'].join(CRDT::DELIMITER))
    end

    it "converts entry into constituent parts" do
      expect(CRDT.parts(['foo',1,'bar'].join(CRDT::DELIMITER))).to eq(['foo',1,'bar'])
    end

    it "returns expected value from entry" do
      items = Array(['foo',1,'bar'].join(CRDT::DELIMITER))
      expect(CRDT.values_for(items)).to eq(['bar'])
    end

    it "returns a list of timestamps for a given key" do
      items = [['foo',1,'bar'].join(CRDT::DELIMITER), ['foo',2,'bar'].join(CRDT::DELIMITER)]
      expect(CRDT.timestamps_for_key('foo', items)).to eq ([1, 2])
    end
  end
end
