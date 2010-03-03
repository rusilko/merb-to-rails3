dir = File.join(File.dirname(__FILE__), "merb-to-rails3")
require "#{dir}/helpers"

module MerbToRails3
  class Railtie < Rails::Railtie
    railtie_name :"merb-to-rails3"

    initializer "merb-to-rails3.rails" do
      class ::ActionController::Base
        extend Helpers::Controller
      end

      module ::ApplicationHelper
        include Helpers::View
      end
    end
  end
end
