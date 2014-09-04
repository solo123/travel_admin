class Photo < ActiveRecord::Base
  has_attached_file :pic, :styles => { :large => '1000x1000>', :small => '300x300>', :thumb => '80x80#' }
	validates_attachment_content_type :pic, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  belongs_to :photo_data, :polymorphic => true
  before_post_process :transliterate_file_name

  def transliterate_file_name
    extension = File.extname(pic_file_name).gsub(/^\.+/, '')
    self.pic.instance_write(:file_name, "#{Time.now.to_i}_#{rand(1000)}.#{extension.downcase}")
  end
  
end
