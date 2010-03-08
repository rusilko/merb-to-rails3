class Exception
  # Returns the action_name that will be invoked on your Exceptions controller when this
  # exception is raised. Override this method to force a different action to be invoked.
  #
  # ==== Returns
  # String:: The name of the action in the Exceptions controller which will get invoked
  #   when this exception is raised during a request.
  #
  # :api: public
  # @overridable
  def action_name() self.class.action_name end


  # ==== Returns
  # Boolean:: Whether or not this exception is the same as another.
  #
  # :api: public
  def same?(other)
    self.class == other.class &&
      self.message == other.message &&
      self.backtrace == other.backtrace
  end

  # Returns the action_name that will be invoked on your Exceptions controller when an instance
  # is raised during a request.
  #
  # ==== Returns
  # String:: The name of the action in the Exceptions controller which will get invoked
  #   when an instance of this Exception sub/class is raised by an action.
  #
  # :api: public
  # @overridable
  def self.action_name
    name = self.to_s.split('::').last.underscore
    ApplicationController.method_defined?(name) ? name : superclass.action_name
  end

  def self.status
    500
  end
end

module MerbToRails3
  module ControllerExceptions

    # Mapping of status code names to their numeric value.
    STATUS_CODES = {}

    class Base < StandardError #:doc:

      # === Returns
      # Integer:: The status-code of the error.
      #
      # @overridable
      # :api: plugin
      def status; self.class.status; end
      alias :to_i :status

      class << self

        # Get the actual status-code for an Exception class.
        #
        # As usual, this can come from a constant upwards in
        # the inheritance chain.
        #
        # ==== Returns
        # Fixnum:: The status code of this exception.
        #
        # :api: public
        def status
          const_get(:STATUS) rescue 0
        end
        alias :to_i :status

        # Set the actual status-code for an Exception class.
        #
        # If possible, set the STATUS constant, and update
        # any previously registered (inherited) status-code.
        #
        # ==== Parameters
        # num<~to_i>:: The status code
        #
        # ==== Returns
        # (Integer, nil):: The status set on this exception, or nil if a status was already set.
        #
        # :api: private
        def status=(num)
          unless self.status?
            register_status_code(self, num)
            self.const_set(:STATUS, num.to_i)
          end
        end

        # See if a status-code has been defined (on self explicitly).
        #
        # ==== Returns
        # Boolean:: Whether a status code has been set
        #
        # :api: private
        def status?
          self.const_defined?(:STATUS)
        end

        # Registers any subclasses with status codes for easy lookup by
        # set_status in Merb::Controller.
        #
        # Inheritance ensures this method gets inherited by any subclasses, so
        # it goes all the way down the chain of inheritance.
        #
        # ==== Parameters
        #
        # subclass<ControllerExceptions::Base>::
        #   The Exception class that is inheriting from ControllerExceptions::Base
        #
        # :api: public
        def inherited(subclass)
          # don't set the constant yet - any class methods will be called after self.inherited
          # unless self.status = ... is set explicitly, the status code will be inherited
          register_status_code(subclass, self.status) if self.status?
        end

        private

        # Register the status-code for an Exception class.
        #
        # ==== Parameters
        # num<~to_i>:: The status code
        #
        # :api: privaate
        def register_status_code(klass, code)
          name = self.to_s.split('::').last.underscore
          STATUS_CODES[name.to_sym] = code.to_i
        end

      end
    end

    class Informational               < ControllerExceptions::Base; end

    class Continue                    < ControllerExceptions::Informational; self.status = 100; end

    class SwitchingProtocols          < ControllerExceptions::Informational; self.status = 101; end

    class Successful                  < ControllerExceptions::Base; end

    class OK                          < ControllerExceptions::Successful; self.status = 200; end

    class Created                     < ControllerExceptions::Successful; self.status = 201; end

    class Accepted                    < ControllerExceptions::Successful; self.status = 202; end

    class NonAuthoritativeInformation < ControllerExceptions::Successful; self.status = 203; end

    class NoContent                   < ControllerExceptions::Successful; self.status = 204; end

    class ResetContent                < ControllerExceptions::Successful; self.status = 205; end

    class PartialContent              < ControllerExceptions::Successful; self.status = 206; end

    class Redirection                   < ControllerExceptions::Base; end

    class MultipleChoices             < ControllerExceptions::Redirection; self.status = 300; end

    class MovedPermanently            < ControllerExceptions::Redirection; self.status = 301; end

    class MovedTemporarily            < ControllerExceptions::Redirection; self.status = 302; end

    class SeeOther                    < ControllerExceptions::Redirection; self.status = 303; end

    class NotModified                 < ControllerExceptions::Redirection; self.status = 304; end

    class UseProxy                    < ControllerExceptions::Redirection; self.status = 305; end

    class TemporaryRedirect           < ControllerExceptions::Redirection; self.status = 307; end

    class ClientError                 < ControllerExceptions::Base; end

    class BadRequest                  < ControllerExceptions::ClientError; self.status = 400; end

    class MultiPartParseError         < ControllerExceptions::BadRequest; end

    class Unauthorized                < ControllerExceptions::ClientError; self.status = 401; end

    class PaymentRequired             < ControllerExceptions::ClientError; self.status = 402; end

    class Forbidden                   < ControllerExceptions::ClientError; self.status = 403; end

    class NotFound                    < ControllerExceptions::ClientError; self.status = 404; end

    class ActionNotFound              < ControllerExceptions::NotFound; end

    class TemplateNotFound            < ControllerExceptions::NotFound; end

    class LayoutNotFound              < ControllerExceptions::NotFound; end

    class MethodNotAllowed            < ControllerExceptions::ClientError; self.status = 405; end

    class NotAcceptable               < ControllerExceptions::ClientError; self.status = 406; end

    class ProxyAuthenticationRequired < ControllerExceptions::ClientError; self.status = 407; end

    class RequestTimeout              < ControllerExceptions::ClientError; self.status = 408; end

    class Conflict                    < ControllerExceptions::ClientError; self.status = 409; end

    class Gone                        < ControllerExceptions::ClientError; self.status = 410; end

    class LengthRequired              < ControllerExceptions::ClientError; self.status = 411; end

    class PreconditionFailed          < ControllerExceptions::ClientError; self.status = 412; end

    class RequestEntityTooLarge       < ControllerExceptions::ClientError; self.status = 413; end

    class RequestURITooLarge          < ControllerExceptions::ClientError; self.status = 414; end

    class UnsupportedMediaType        < ControllerExceptions::ClientError; self.status = 415; end

    class RequestRangeNotSatisfiable  < ControllerExceptions::ClientError; self.status = 416; end

    class ExpectationFailed           < ControllerExceptions::ClientError; self.status = 417; end

    class ServerError                 < ControllerExceptions::Base; end

    class InternalServerError         < ControllerExceptions::ServerError; self.status = 500; end

    class NotImplemented              < ControllerExceptions::ServerError; self.status = 501; end

    class BadGateway                  < ControllerExceptions::ServerError; self.status = 502; end

    class ServiceUnavailable          < ControllerExceptions::ServerError; self.status = 503; end

    class GatewayTimeout              < ControllerExceptions::ServerError; self.status = 504; end

    class HTTPVersionNotSupported     < ControllerExceptions::ServerError; self.status = 505; end
  end

  # Required to show exceptions in the log file
  #
  # e<Exception>:: The exception that a message is being generated for
  #
  # :api: plugin
  def self.exception(e)
    "#{ e.message } - (#{ e.class })\n" <<
      "#{(e.backtrace or []).join("\n")}"
  end
end
