require 'fog/aws/storage'
require 'carrierwave'

CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage :fog
    
    config.fog_credentials = {
      :provider               => 'AWS',   # required
      :aws_access_key_id      => Rails.application.secrets.aws_access_key_id,    # required
      :aws_secret_access_key  => Rails.application.secrets.aws_secret_access_key   # required
    }
    config.fog_directory  = "marksoftware/myflix-#{Rails.env}"   # required
    config.fog_public     = false   # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}    # optional, defaults to {}
  else
    config.storage :file
    config.enable_processing = Rails.env.development?
  end
  
end
