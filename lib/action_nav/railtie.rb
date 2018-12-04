module ActionNav
  class Railtie < Rails::Railtie

    initializer 'actionnav.initialize' do |app|
      ActiveSupport.on_load :action_controller do
        require 'action_nav/controller_extension'
        include ActionNav::ControllerExtension
      end
    end

  end
end
