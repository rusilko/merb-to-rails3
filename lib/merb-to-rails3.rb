dir = File.join(File.dirname(__FILE__), "merb-to-rails3")

require "#{dir}/helpers"
require "#{dir}/controller_exceptions"

module MerbToRails3
  class Railtie < Rails::Railtie
    initializer "merb-to-rails3.rails" do
      class ::ActionController::Base
        extend  MerbToRails3::Helpers::Controller
        include MerbToRails3::ControllerExceptions
      end

      module ::ApplicationHelper
        include MerbToRails3::Helpers::View
      end
    end
  end
end
