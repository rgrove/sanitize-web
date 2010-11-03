require 'rubygems'

gem 'sanitize', '>= 1.2.0'

require 'ramaze'
require 'sanitize'

require './lib/helper/error'

class MainController < Ramaze::Controller
  helper :error
  engine :Erubis

  def index
    response['Content-Type'] = 'text/html; charset=UTF-8'

    if request.post?
      @config_name     = request[:config].strip.downcase
      @remove_contents = request[:remove_contents] == '1'

      unless ['basic', 'restricted', 'relaxed'].include?(@config_name)
        @config_name = 'default'
      end

      @config = Sanitize::Config.const_get(@config_name.upcase).dup

      if @remove_contents
        @config.merge!(:remove_contents => true)
      end

      @html_raw = request[:html]
      @html     = Sanitize.clean(@html_raw, @config)
    end
  end

  # Displays a custom 404 error when a nonexistent action is requested.
  def self.action_missing(path)
    return if path == '/error_404'
    try_resolve('/error_404')
  end
end
