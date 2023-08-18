SchemaRegistry.configure do |config|
  config.schemas_root_path = Rails.root.join('app', 'schemas')
end
