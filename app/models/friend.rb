require "open-uri"

class Friend < ActiveRecord::Base
	  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200>',
    medium: '300x300>',
    large: '400X400>'
  }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  belongs_to :user

  def picture_from_url(url)
    self.avatar = open(url)
  end
end
