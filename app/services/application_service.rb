require 'json'
# The root service class
class ApplicationService
  attr_reader :params
  attr_accessor :result

  # @note: This method is responsible for initializing the service.
  # @param [Hash] params
  def initialize(params = {})
    @params = params.is_a?(String) ? JSON.parse(params, symbolize_names: true) : params
    @result = Struct.new(:data, :success, :errors)
  end

  def self.call(params)
    new(params).call
  end

  def call
    raise NotImplementedError, 'Subclasses must implement a #call method'
  end

  def log_event(user:, data: {})
    event_data = { user:, data:, class_name: self.class.to_s }.compact
    AuditLog.create(event_data)
  end
end
