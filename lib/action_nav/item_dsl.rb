module ActionNav
  class ItemDSL

    def initialize(item)
      @item = item
    end

    def title(title = nil, &block)
      @item.title = block_given? ? block : title
    end

    def url(url = nil, &block)
      @item.url = block_given? ? block : url
    end

    def description(description = nil, &block)
      @item.description = block_given? ? block : description
    end

    def icon(icon = nil, &block)
      @item.icon = block_given? ? block : icon
    end

    def meta(meta = {}, &block)
      @item.meta = block_given? ? block : meta
    end

    def hide_unless(&block)
      @item.hide_unless = block
    end

    def item(id, &block)
      child = @item.add_child(id)
      child.dsl(&block)
      child
    end

    def count(&block)
      if block_given?
        @item.count = block
      else
        raise ArgumentError, "Block must be provided to `count`"
      end
    end

  end
end
