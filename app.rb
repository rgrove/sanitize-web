require 'rubygems'

gem 'sanitize', '>= 1.2.0'

require 'ramaze'
require 'sanitize'

require 'lib/helper/error'

class MainController < Ramaze::Controller
  helper :error
  engine :Erubis

  def index
    response['Content-Type'] = 'text/html; charset=UTF-8'

    if request.post?
      @config = request[:config].strip.downcase
      
      unless ['basic', 'restricted', 'relaxed'].include?(@config)
        @config = 'default'
      end

      @html_raw = request[:html]
      @html     = Sanitize.clean(@html_raw, Sanitize::Config.const_get(@config.upcase))
    end
  end

  # Displays a custom 404 error when a nonexistent action is requested.
  def self.action_missing(path)
    return if path == '/error_404'
    try_resolve('/error_404')
  end
end
