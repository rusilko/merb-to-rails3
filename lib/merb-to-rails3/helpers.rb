def merb_deprec(notice=nil)
  msg = "!!! #{caller.first[/in `(.+)'$/, 1]} IS DEPRECATED (found at #{self}:#{caller.first[/:(\d+):in/, 1]})"
  if notice
    msg << ": #{notice}"
  end
  Rails.logger.warn(msg)
end

module MerbToRails3
  module Helpers
    module ViewAndController
      def url(name)
        path = "#{name}_path"
        merb_deprec("use #{path}")
        send(path)
      end

      def resource(*args)
        opts_hash = args.last.is_a?(Hash) ? args.pop : {}
        action = args.pop if args.size > 1 && [:new, :edit, :delete].include?(args.last)
        objects = []
        resources = args.map do |a|
          if a.is_a?(String) || a.is_a?(Symbol)
            a.to_s.underscore
          else
            objects << a
            a.class.to_s.underscore
          end
        end
        if action
          resources.unshift(action)
          resources << resources.pop.to_s.singularize
        end
        path = "#{resources.join('_')}_path"
        merb_deprec("use #{path}")
        objects.empty? ? send(path, opts_hash) : send(path, *(objects << opts_hash))
      end

      def partial(name, opts={})
        merb_deprec("use render :partial")
        args = { :partial => name.to_s, :locals => opts }
        if opts.key?(:with)
          args[:object] = opts.delete(:with)
        end
        render args
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

      def throw_content(name, *args, &blk)
        content_for(name, *args, &blk)
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
          opts = args.dup.extract_options!

          if message = opts.delete(:message)
            message.each { |type, text| flash[type] = text }
            merb_deprec("use flash instead of :message option in redirect")
          end

          merb_deprec("use redirect_to")

          redirect_to(*args)
        end
      end
    end
  end
end
