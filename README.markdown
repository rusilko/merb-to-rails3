# merb-to-rails3

## About

**merb-to-rails3** is a gem which adds several methods from Merb's API to your Rails 3 app in order to ease updating existing Merb app to Rails.

Things covered:

Controller:

 * redirect => redirect_to
 * before => before_filter
 * after => after_filter

Controller/View:

 * url(name) => name_path
 * resource(...) => ....._path
 * submit => submit_tag
 * css_include_tag => stylesheet_link_tag
 * js_include_tag => javascript_include_tag
 * throw_content(name) => content_for(name)
 * partial => render :partial
