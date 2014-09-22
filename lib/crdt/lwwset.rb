module CRDT
  class LWWSet
    def initialize()
      @items = Set.new
      @deletes = Set.new
    end

    def insert(key, timestamp, value)
      timestamps = CRDT::timestamps_for_key(key, @items)
      if timestamps.size > 0 && timestamps.max < timestamp
        #Update value by deleting old value
        @deletes += items_for_key(key, @items)
      end
      # insert
      @items << CRDT.entry_for(key, timestamp, value)
    end

    def delete(key, timestamp, value)
      @deletes << CRDT.entry_for(key, timestamp, value)
    end

    def values
      CRDT.values_for(reconcile(@items, @deletes)).uniq
    end

    private

    def items_for_key(key, list)
      list.select{|item| CRDT.parts(item).first == key}
    end

    # Return the list of items not contained in the list of deletes
    def reconcile(items, deletes)
      items.entries.select do |item|
        parts = CRDT.parts(item)
        name = parts.first
        item_ts = CRDT::timestamps_for_key(name, items).compact
        deletes_ts = CRDT::timestamps_for_key(name, deletes).compact
        recent_item_ts = item_ts.max || 0
        recent_delete_ts = deletes_ts.max || 0
        recent_item_ts > recent_delete_ts
      end
    end

  end
end
