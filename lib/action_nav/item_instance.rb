require 'active_support/inflector/methods'

module ActionNav
  class ItemInstance

    attr_reader :item

    def initialize(base, item)
      @base = base
      @item = item
    end

    def id
      @item.id
    end

    def path
      @item.path
    end

    def items
      @item.children.each_with_object([]) do |(_, item), array|
        instance = ItemInstance.new(@base, item)
        unless instance.hidden?
          array << instance
        end
      end
    end

    def active?
      @base.active_path?(*self.path)
    end

    def title
      cache(:title) { parse(@item.title, ActiveSupport::Inflector.humanize(@item.id.to_s)) }
    end

    def description
      cache(:description) { parse(@item.description) }
    end

    def description?
      !!description
    end

    def url
      cache(:url) { parse(@item.url, "/")}
    end

    def icon
      cache(:icon) { parse(@item.icon) }
    end

    def icon?
      !!icon
    end

    def hidden?
      cache(:hidden?) do
        if @item.hide_unless
          parse(@item.hide_unless, false) == false
        else
          false
        end
      end
    end

    def count
      @item.count ? @count ||= @item.count.call : nil
    end

    private

    def parse(item, default = nil)
      if item.is_a?(Proc)
        @base.controller.instance_eval(&item)
      elsif item
        item.to_s
      else
        default
      end
    end

    def cache(name, &block)
      @cache ||= {}
      if @cache.keys.include?(name)
        @cache[name]
      else
        @cache[name] = block.call
      end
    end

  end
end
