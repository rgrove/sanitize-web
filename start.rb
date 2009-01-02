require 'rubygems'

gem 'manveru-ramaze', '=2008.12'

require 'ramaze'
require 'sanitize'

Ramaze::Global.sourcereload = false

class MainController < Ramaze::Controller
  engine :Erubis

  def index
    if request.post?
      @config = request[:config].strip.downcase

      unless ['basic', 'restricted', 'relaxed'].include?(@config)
        @config = 'default'
      end

      @html_raw = request[:html]
      @html     = Sanitize.clean(@html_raw, Sanitize::Config.const_get(@config.upcase))
    end
  end
end
