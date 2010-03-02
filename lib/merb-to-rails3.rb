module MerbToRails3
  module Deprec
    def merb_deprec(notice=nil)
      msg = "!!! #{caller.first[/in `(.+)'$/, 1]} IS DEPRECATED (found at #{self.inspect}:#{caller.first[/:(\d+):in/, 1]})"
      if notice
        msg << ": #{notice}"
      end
      Rails.logger.warn(msg)
    end
  end
end

dir = File.join(File.dirname(__FILE__), "merb-to-rails3")
require "#{dir}/helpers"
