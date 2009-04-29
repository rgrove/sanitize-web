module Ramaze; module Helper
 
  # The Error helper module provides methods for interrupting the current
  # request and responding with an error message and corresponding HTTP error
  # code.
  module Error
    Helper::LOOKUP << self
 
    # Displays a "400 Bad Request" error message and returns a 400 response
    # code.
    def error_400(message = nil)
      if message
        error_layout 400, '400 Bad Request', %[
          <p>
          Your browser sent a request that this server could not understand.
          </p>
 
          <p>
          #{message}
          </p>
        ]
      else
        error_layout 400, '400 Bad Request', %[
          <p>
          Your browser sent a request that this server could not understand.
          </p>
        ]
      end
    end
 
    # Displays a "403 Forbidden" error message and returns a 403 response code.
    def error_403
      error_layout 403, '403 Forbidden', %[
        <p>
        You don't have permission to access
        <code>#{h(request.REQUEST_URI)}</code> on this server.
        </p>
      ]
    end
 
    # Displays a "404 Not Found" error message and returns a 404 response code.
    def error_404
      error_layout 404, '404 Not Found', %[
        <p>
        The requested URL <code>#{h(request.REQUEST_URI)}</code> was not
        found on this server.
        </p>
      ]
    end
    
    # Displays a "405 Method Not Allowed" error message and returns a 405
    # response code.
    def error_405
      error_layout 405, '405 Method Not Allowed', %[
        <p>
        The #{request.env['REQUEST_METHOD']} method is not allowed for the
        requested URL.
        </p>
      ]
    end
 
    # Displays a "500 Internal Server Error" error message and returns a 500
    # response code.
    def error_500
      if e = request.env[Rack::RouteExceptions::ROUTE_EXCEPTIONS_EXCEPTION]
        Ramaze::Log.error e
      end
 
      error_layout 500, '500 Internal Server Error', %[
        <p>
        The server encountered an internal error and was unable to complete
        your request.
        </p>
      ]
    end
 
    private
 
    def error_layout(status, title, content = '')
      respond %[
        <html>
        <head>
          <title>#{h(title)}</title>
        </head>
        <body>
          <h1>#{h(title)}</h1>
          #{content}
        </body>
        </html>
      ].unindent, status
    end
  end
 
end; end
