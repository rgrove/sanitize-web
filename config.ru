require 'app'

Ramaze.middleware!(:live) do |m|
  m.use Rack::CommonLogger
  m.use Rack::RouteExceptions
  m.use Rack::Head
  m.run Ramaze::AppMap
end

Ramaze.start(:file => __FILE__, :started => true, :mode => :live)
run Ramaze
