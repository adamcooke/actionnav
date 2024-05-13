require 'action_nav/item_dsl'

module ActionNav
  class Item

    def initialize(parent, id)
      @id = id
      @parent = parent
      @children = {}
    end

    attr_reader :id
    attr_reader :children
    attr_accessor :title
    attr_accessor :url
    attr_accessor :description
    attr_accessor :icon
    attr_accessor :meta
    attr_accessor :hide_unless
    attr_accessor :count

    def path
      @parent ? [@parent.path, id].flatten : [id]
    end

    def add_child(id, &block)
      child_item = Item.new(self, id)
      block.call(child_item) if block_given?
      @children[id] = child_item
    end

    def child(*ids)
      previous = self
      ids.each do |id|
        previous = previous.children[id]
        return nil if previous.nil?
      end
      previous
    end

    def dsl(&block)
      ItemDSL.new(self).instance_eval(&block)
      self
    end

  end
end
