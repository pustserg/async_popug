KAFKA_PRODUCER = WaterDrop::Producer.new

KAFKA_PRODUCER.setup do |cfg|
  cfg.kafka = { 'bootstrap.servers': 'kafka:29092' }
end
