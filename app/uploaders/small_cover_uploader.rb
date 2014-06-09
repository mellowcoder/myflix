# encoding: utf-8

class SmallCoverUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # storage is specified in the initializer

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    ActionController::Base.helpers.asset_path("fallback/" + ['166x236', "default.jpg"].compact.join('_'))
  end

  # Process files as they are uploaded:
  process :resize_to_fit => [166, 236]

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
