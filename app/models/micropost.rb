class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.maximum_content}
  validate  :picture_size

  scope :order_created_at, -> {order(created_at: :desc)}
  scope :by_user, -> user_id {where user_id: user_id}

  private

  def picture_size
    if picture.size > Settings.validate_size_image.megabytes
      errors.add :picture, (t "micropost.validate_picture_size")
    end
  end
end
