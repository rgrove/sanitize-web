# encoding: utf-8
require 'bundler'

Bundler.require

require 'sinatra/base'

class Sanitize::Web < Sinatra::Base
  MAX_REQUEST_LENGTH = 1024 * 1024

  disable :protection
  disable :show_exceptions
  enable  :logging

  # -- Routes ------------------------------------------------------------------
  before do
    cache_control :private, :no_cache, :max_age => 0
    content_type 'text/html', :charset => 'utf-8'

    headers['X-XSS-Protection'] = '0'

    @title = 'Sanitize Online Demo'

    unless request.content_length.to_i <= MAX_REQUEST_LENGTH
      error(413, "Request too large. Must not exceed #{MAX_REQUEST_LENGTH} bytes.")
    end
  end

  get '/' do
    erb :index
  end

  post '/' do
    @config_name     = params[:config].strip.downcase
    @document        = params[:document] == '1'
    @remove_contents = params[:remove_contents] == '1'

    unless %w[basic restricted relaxed].include?(@config_name)
      @config_name = 'default'
    end

    @config = Sanitize::Config.const_get(@config_name.upcase)

    if @remove_contents
      @config = Sanitize::Config.merge(@config, :remove_contents => true)
    end

    @html_raw = params[:html] || ''

    begin
      @html = @document ? Sanitize.document(@html_raw, @config) : Sanitize.fragment(@html_raw, @config)
    rescue Exception => ex
      error(400, ex.to_s)
    end

    erb :index
  end

  # -- Helpers -----------------------------------------------------------------
  def error(code = 500, message = nil)
    @code    = code
    @message = message
    @title   = "Error #{code} - #{@title}"

    halt([code, erb(:error)])
  end
end
