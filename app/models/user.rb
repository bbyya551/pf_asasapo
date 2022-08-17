class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end

    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  has_many :announcements, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :group_users
  has_many :groups, through: :group_users

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  #フォローする側からのhas_manyなので、それがわかるようにforeign_keyでfollower_id(フォローする人)を指定してやる
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  #「has_many :followings」は任意の名前。意味合いは、自分がフォローしている人。
  #すなわち、フォローされている人。すなわち、自分から見てフォローされている人全員なので、中間テーブルをthroughして、source: :followedとして自分とは反対側のfollowedモデルを参照してくる必要あり。
  has_many :followings, through: :relationships, source: :followed

  #フォローされる側からのhas_manyなので、foreign_keyでfollowed_id(フォローされる人)を指定してやる
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end

  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end
end
