class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users

  validates :name, presence: true
  validates :introduction, presence: true
  has_one_attached :image

  def get_image(width, height)
   unless image.attached?
     file_path = Rails.root.join('app/assets/images/group_default.jpg')
     image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
   end
  image.variant(resize_to_limit: [width, height]).processed
  end

  def includesUser?(user)
    group_users.exists?(user_id: user.id)
  end

  def self.search_for(content, method)
    if method == 'perhect'
      Group.where(name: content)
    elsif method == 'forward'
      Group.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      Group.where('name LIKE ?', '%' + content)
    else
      Group.where('name LIKE ?', '%' + content + '%')
    end
  end
end
