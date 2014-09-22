module CRDT
  class RoshiSet
    def initialize()
      @items = Set.new
      @deletes = Set.new
    end

    def insert(key, timestamp, value)
      new_entry = CRDT.entry_for(key, timestamp, value)
      item = existing_entry_for(key, @items)
      deleted = existing_entry_for(key, @deletes)
      if item && CRDT.parts(item)[1] < timestamp
        replace_key!(item, new_entry, @items)
      elsif deleted && CRDT.parts(item)[1] < timestamp
        @deletes.delete(deleted)
        @items << new_entry
      else
        @items << new_entry
      end
    end

    def delete(key, timestamp, value)
      item = existing_entry_for(key, @items)
      if item && CRDT.parts(item)[1] < timestamp
        @items.delete(item)
        @deletes << CRDT.entry_for(key, timestamp, value)
      else
        replace_key!(item, CRDT.entry_for(key, timestamp, value), @deletes)
      end
    end

    def values
      CRDT.values_for(@items).uniq
    end

    private

    def existing_entry_for(name, list)
      list.select{|item| CRDT.parts(item).first == name}.compact.first
    end

    # Return the list of items not contained in the list of deletes
    def reconcile(items, deletes)
      items.entries.select do |item|
        parts = CRDT.parts(item)
        name = parts.first
        item_ts = CRDT.timestamps_for_key(name, items).compact
        deletes_ts = CRDT.timestamps_for_key(name, deletes).compact
        recent_item_ts = item_ts.max || 0
        recent_delete_ts = deletes_ts.max || 0
        recent_item_ts > recent_delete_ts
      end
    end

    def replace_key!(old_entry, new_entry, list)
      list.delete(old_entry).add(new_entry)
    end

  end
end
