require 'action_nav/set'

module ActionNav
  module ControllerExtension

    def self.included(base)
      base.class_eval do
        helper_method :navigation if respond_to?(:helper_method)
      end
    end

    def navigation
      @navigation ||= Set.new(self)
    end

  end
end
