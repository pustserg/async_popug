# check Homework week2

class Producer
  InvalidTopic = Class.new(ArgumentError)

  TOPICS_MAPPING = {
    'user_registered' => 'auth.user_registered',
    'user_updated' => 'auth.user_updated'
  }.freeze

  class << self
    def publish(event_type:, payload:)
      raise InvalidTopic unless TOPICS_MAPPING.key?(event_type)

      Rails.logger.info "Publishing #{event_type} with #{payload} to topic #{TOPICS_MAPPING[event_type]}"
      producer.produce_async(payload: JSON.generate(payload), topic: TOPICS_MAPPING[event_type])
    end

    def producer
      return @producer if @producer

      @producer = WaterDrop::Producer.new
      @producer.setup do |config|
        config.kafka = { 'bootstrap.servers': 'kafka:29092' }
      end
      @producer
    end
  end
end
