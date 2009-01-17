require 'rubygems'

gem 'ramaze', '=2009.01'

require 'ramaze'
require 'sanitize'

require 'lib/helper/error'

Ramaze::Global.sourcereload = false

Ramaze::Dispatcher::Error::HANDLE_ERROR.update({
  Ramaze::Error::NoAction     => [404, 'error_404'],
  Ramaze::Error::NoController => [404, 'error_404']
})

Ramaze::Dispatcher::Error::HANDLE_ERROR.update({
  ArgumentError => [404, 'error_404'],
  Exception     => [500, 'error_500']
})

class MainController < Ramaze::Controller
  helper :error
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
