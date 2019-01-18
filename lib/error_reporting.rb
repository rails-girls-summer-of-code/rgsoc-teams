# frozen_string_literal: true

require 'sentry-raven'

# Facade to log custom errors to our exception tracking service
# (currently Sentry).
class ErrorReporting
  class << self
    # @param msg_or_exception [Exception, String] data to send to Sentry.io
    def call(msg_or_exception)
      capture_method = case msg_or_exception
                       when Exception then :capture_exception
                       else :capture_message
                       end

      Raven.public_send(capture_method, msg_or_exception)
    end
  end
end
