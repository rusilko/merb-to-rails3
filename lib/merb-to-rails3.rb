def deprec(notice=nil)
  msg = "!!! #{caller.first[/in `(.+)'$/, 1]} IS DEPRECATED (found at #{self.class}:#{caller.first[/:(\d+):in/, 1]})"
  if notice
    msg << ": #{notice}"
  end
  Rails.logger.warn(msg)
end

def url(name)
  path = "#{name}_path"
  deprec("use #{path}")
  send(path)
end

def redirect(*args)
  deprec("use redirect_to")
  redirect_to(*args)
end

class ActionController::Base
  def self.before(*args)
    deprec("use before_filter")
    before_filter(*args)
  end
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
  deprec("use #{path}")
  send(path)
end

def submit(value, options)
  deprec("use submit_tag")
  submit_tag(value, options)
end

def css_include_tag(*args)
  deprec("use stylesheet_link_tag")
  stylesheet_link_tag(*args)
end

def js_include_tag(*args)
  deprec("use javascript_include_tag")
  javascript_include_tag(*args)
end

def catch_content(name)
  yield(name) if block_given?
end

def partial(name, opts={})
  render opts.merge(:partial => name.to_s)
end

