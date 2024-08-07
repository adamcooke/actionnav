require 'action_nav/item'
require 'action_nav/item_instance'
require 'action_nav/item_dsl'

module ActionNav
  class Base

    # Initialize a new navigation
    #
    # @param controller [ActionController::Base]
    # @return [ActionNav::Base]
    def initialize(controller)
      @controller = controller
      @active_paths = []
      @context = {}
    end

    # The controller that initialized this navigation.
    #
    # @return [ActionController::Base]
    attr_reader :controller
    attr_reader :active_paths

    # The context for this navigation.
    # 
    # @return [Hash]
    attr_reader :context

    # Return a full list of items for this instance as
    # instances.
    #
    # @return [Array<ActionNav::ItemInstance>]
    def items
      @items ||= self.class.items.each_with_object([]) do |(key, item), array|
        instance = ItemInstance.new(self, item)
        unless instance.hidden?
          array << instance
        end
      end
    end

    # Add an active navigation by passing the full path to
    # active item.
    def activate(*parts)
      @active_paths.push(parts)
    end
    alias_method :active, :activate

    # Is the given active path?
    #
    # @return [Boolean]
    def active_path?(*parts)
      @active_paths.any? do |path|
        a = path.size.times.map { |i| path[0, path.size - i] }
        a.include?(parts)
      end
    end

    # Add context to this navigation.
    # 
    # @param key [Symbol]
    # @param value [Object]
    # @return [Hash]
    def add_context(key, value)
      @context[key] = value
    end

    # Add a new item to this navigation
    #
    # @param id [Symbol]
    # @return [ActionNav::Item]
    def self.item(id, &block)
      item = Item.new(nil, id)
      item.dsl(&block) if block_given?
      items[id] = item
    end

    # Return all items for this navigation
    #
    # @return [Hash]
    def self.items
      @items ||= {}
    end

  end
end
