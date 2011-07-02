require 'rubygems'

gem 'sanitize', '>= 2.0.3'

require 'erubis'
require 'sinatra/base'
require 'sanitize'

class Sanitize::Web < Sinatra::Base
  set :logging, true

  get '/' do
    content_type 'text/html', :charset => 'utf-8'
    erubis(:index)
  end

  post '/' do
    content_type 'text/html', :charset => 'utf-8'

    @config_name     = params[:config].strip.downcase
    @remove_contents = params[:remove_contents] == '1'

    unless ['basic', 'restricted', 'relaxed'].include?(@config_name)
      @config_name = 'default'
    end

    @config = Sanitize::Config.const_get(@config_name.upcase).dup

    if @remove_contents
      @config.merge!(:remove_contents => true)
    end

    @html_raw = params[:html]
    @html     = Sanitize.clean(@html_raw, @config)

    erubis(:index)
  end
end
