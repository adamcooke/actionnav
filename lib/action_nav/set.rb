require 'active_support/inflector/inflections'

module ActionNav
  class Set

    def initialize(controller)
      @controller = controller
      @navigations = {}
    end

    def [](name)
      @navigations[name] ||= begin
        "#{name.to_s}_navigation".classify.constantize.new(@controller)
      end
    end

  end
end
