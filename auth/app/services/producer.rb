class Producer
  InvalidTopic = Class.new(ArgumentError)
  NoSchema = Class.new(ArgumentError)

  TOPICS_MAPPING = {
    'user_registered' => 'auth.user_registered',
    'user_changed' => 'auth.user_updated'
  }.freeze
  SCHEMAS_MAPPING = {
    'user_registered' => 'auth.user.registered',
    'user_changed' => 'auth.user.updated'
  }.freeze

  class << self
    def publish(event_type:, payload:)
      raise InvalidTopic unless TOPICS_MAPPING.key?(event_type)
      raise NoSchema unless SCHEMAS_MAPPING.key?(event_type)

      event_payload = generate_payload(event_type, payload)

      # check homework week3
      result = SchemaRegistry.validate_event(event_payload, SCHEMAS_MAPPING[event_type], version: 2)
      if result.success?
        Rails.logger.info "Publishing #{event_type} with #{event_payload} to topic #{TOPICS_MAPPING[event_type]}"
        producer.produce_async(payload: JSON.generate(event_payload), topic: TOPICS_MAPPING[event_type])
      else
        Rails.logger.error "Invalid payload #{event_payload} for #{event_type} version 2"
      end
    end

    private

    def generate_payload(event_type, payload)
      {
        event_id: SecureRandom.uuid,
        event_version: 1,
        event_name: event_type,
        event_time: Time.now.utc.iso8601,
        producer: 'Auth',
        data: payload
      }
    end

    def producer
      return @producer if @producer

      @producer = WaterDrop::Producer.new
      @producer.setup do |config|
        config.kafka = { 'bootstrap.servers': 'kafka:9092' }
      end
      @producer
    end
  end
end
