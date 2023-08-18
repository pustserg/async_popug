class Producer
  InvalidTopic = Class.new(ArgumentError)
  NoSchema = Class.new(ArgumentError)

  TOPICS_MAPPING = {
    'transaction_created' => 'accounts.transaction_created',
  }.freeze

  SCHEMAS_MAPPING = {
    'transaction_created' => 'transaction.created'
  }.freeze

  class << self
    def publish(event_type:, payload:)
      raise InvalidTopic unless TOPICS_MAPPING.key?(event_type)
      raise NoSchema unless SCHEMAS_MAPPING.key?(event_type)

      event_payload = generate_payload(event_type, payload)
      Rails.logger.info "Publishing #{event_type} with #{event_payload} to topic #{TOPICS_MAPPING[event_type]}"
      producer.produce_async(payload: JSON.generate(event_payload), topic: TOPICS_MAPPING[event_type])
    end

    private

    def generate_payload(event_type, payload)
      {
        event_id: SecureRandom.uuid,
        event_version: 1,
        event_name: event_type,
        event_time: Time.now.utc.iso8601,
        producer: 'Accounts',
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
