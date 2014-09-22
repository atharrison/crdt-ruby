module CRDT

  DELIMITER = ENV['CRDT_DELIMITER'] || ':'

  def self.entry_for(key, timestamp, value)
    [key, timestamp, value].join(DELIMITER)
  end

  def self.parts(item)
    split = item.split(DELIMITER)
    [split[0], split[1].to_i, split[2]]
  end

  def self.values_for(items)
    items.map{|v| parts(v).last}
  end

  def self.timestamps_for_key(key, list)
    [] if list.size == 0
    timestamps = list.reduce([]) do |ts, item|
      parts = parts(item)
      ts << parts[1] if parts.first == key
      ts
    end
    timestamps
  end

end

require 'crdt/counter'
require 'crdt/lwwset'
require 'crdt/roshiset'
