module CRDT
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
end
