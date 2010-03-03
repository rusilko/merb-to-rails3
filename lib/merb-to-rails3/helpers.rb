module MerbToRails3
  module Helpers
    module ViewAndController
      def merb_deprec(notice=nil)
        msg = "!!! #{caller.first[/in `(.+)'$/, 1]} IS DEPRECATED (found at #{self.inspect}:#{caller.first[/:(\d+):in/, 1]})"
        if notice
          msg << ": #{notice}"
        end
        Rails.logger.warn(msg)
      end

      def url(name)
        path = "#{name}_path"
        merb_deprec("use #{path}")
        send(path)
      end

      def resource(*args)
        action = args.pop if args.last.is_a?(Symbol)
        resources = args.map do |a|
          a.to_s.underscore
        end
        if action
          resources.unshift(action)
          resources << resources.pop.singularize
        end
        path = "#{resources.join('_')}_path"
        merb_deprec("use #{path}")
        send(path)
      end

      def redirect(*args)
        merb_deprec("use redirect_to")
        redirect_to(*args)
      end

      def partial(name, opts={})
        merb_deprec("use render :partial")
        render opts.merge(:partial => name.to_s)
      end
      
      def message
        merb_deprec("use flash")
        flash
      end
    end

    module View
      include ViewAndController

      def submit(value, options)
        merb_deprec("use submit_tag")
        submit_tag(value, options)
      end

      def css_include_tag(*args)
        merb_deprec("use stylesheet_link_tag")
        stylesheet_link_tag(*args)
      end

      def js_include_tag(*args)
        merb_deprec("use javascript_include_tag")
        javascript_include_tag(*args)
      end

      def catch_content(name)
        merb_deprec("use yield(#{name})")
        yield(name) if block_given?
      end
    end

    module Controller
      def self.extended(base)
        base.send(:include, InstanceMethods)
      end

      def before(*args)
        merb_deprec("use before_filter")
        before_filter(*args)
      end

      def after(*args)
        merb_deprec("use after_filter")
        after_filter(*args)
      end

      module InstanceMethods
        include ViewAndController

        def redirect(*args)
          merb_deprec("use redirect_to")
          redirect_to(*args)
        end
      end
    end
  end
end
