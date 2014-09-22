module CRDT

  DELIMITER = ':'

  def self.entry_for(name, timestamp, value)
    [name, timestamp, value].join(DELIMITER)
  end

  def self.parts(item)
    item.split(DELIMITER)
  end

  def self.values_for(items)
    items.map{|v| parts(v).last}
  end

  class Counter
    def initialize()
      @increments = Set.new
      @decrements = Set.new
    end

    def inc(name, timestamp)
      @increments << CRDT.entry_for(name, timestamp, 1)
    end

    def dec(name, timestamp)

      @decrements << CRDT.entry_for(name, timestamp, 1)
    end

    def value
      @increments.size - @decrements.size
    end

  end

  class LWWSet
    def initialize()
      @items= Set.new
      @deletes = Set.new
    end

    def insert(name, timestamp, value)
      timestamps = timestamps_for_name(name, @items)
      if timestamps.size > 0 && timestamps.max < timestamp
        #Update value by deleting old value
        @deletes += items_for_name(name, @items)
        # @items.delete(prev_item)
      end
      # insert
      @items << CRDT.entry_for(name, timestamp, value)
    end

    def delete(name, timestamp, value)
      @deletes << CRDT.entry_for(name, timestamp, value)
    end

    def values
      CRDT.values_for(reconcile(@items, @deletes))
    end

    private

    def items_for_name(name, list)
      list.select{|item| CRDT.parts(item).first == name}
    end

    def reconcile(items, deletes)
      values = Set.new
      items.map do |item|
        parts = CRDT.parts(item)
        name = parts.first
        value = parts.last
        item_ts = timestamps_for_name(name, @items).compact
        deletes_ts = timestamps_for_name(name, @deletes).compact
        recent_item_ts = item_ts.max || 0
        recent_delete_ts = deletes_ts.max || 0
        values += Array(value) if recent_item_ts > recent_delete_ts
      end
      values
    end

    def timestamps_for_name(name, list)
      [] if list.size == 0
      timestamps = list.reduce([]) do |ts, item|
        parts = CRDT::parts(item)
        ts << parts[1] if parts.first == name
        ts
      end
      timestamps.map(&:to_i)
    end

    def remove_name!(name, list)
      list.select{|item| CRDT.parts(item) != name }
    end

  end
end
