module MerbToRails3
  module Helpers
    module ViewAndController
      def url(name)
        path = "#{name}_path"
        MerbToRails3.deprec("use #{path}")
        send(path)
      end

      def resource(*args)
        verb = args.pop if args.last.is_a?(Symbol)
        resources = args.map do |a|
          a.to_s.underscore
        end
        if verb
          resources.unshift(verb)
          resources << resources.pop.singularize
        end
        path = "#{resources.join('_')}_path"
        MerbToRails3.deprec("use #{path}")
        send(path)
      end

      def redirect(*args)
        MerbToRails3.deprec("use redirect_to")
        redirect_to(*args)
      end

      def partial(name, opts={})
        MerbToRails3.deprec("use render :partial")
        render opts.merge(:partial => name.to_s)
      end
    end

    module View
      include ViewAndController

      def submit(value, options)
        MerbToRails3.deprec("use submit_tag")
        submit_tag(value, options)
      end

      def css_include_tag(*args)
        MerbToRails3.deprec("use stylesheet_link_tag")
        stylesheet_link_tag(*args)
      end

      def js_include_tag(*args)
        MerbToRails3.deprec("use javascript_include_tag")
        javascript_include_tag(*args)
      end

      def catch_content(name)
        MerbToRails3.deprec("use yield(#{name})")
        yield(name) if block_given?
      end
    end

    module Controller
      def self.extended(base)
        base.send(:include, InstanceMethods)
      end

      def before(*args)
        MerbToRails3.deprec("use before_filter")
        before_filter(*args)
      end

      module InstanceMethods
        include ViewAndController

        def redirect(*args)
          MerbToRails3.deprec("use redirect_to")
          redirect_to(*args)
        end
      end
    end
  end
end
