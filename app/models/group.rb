class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users, dependent: :destroy
  has_many :group_tags, dependent: :destroy
  has_many :tags, through: :group_tags
  has_many :reviews, dependent: :destroy
  # accepts_nested_attributes_for :tags
  # accepts_nested_attributes_for :group_tags


  validates :name, presence: true
  validates :introduction, presence: true
  validates :owner_id, presence: true
  has_one_attached :image

  def get_image(width, height)
   unless image.attached?
     file_path = Rails.root.join('app/assets/images/group_default.jpg')
     image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    # image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
   end
  image.variant(resize_to_limit: [width, height]).processed
  end

  def includesUser?(user)
    group_users.exists?(user_id: user.id)
  end

  def save_tags(tag_list)
    tag_list.each do |tag|
      unless find_tag = Tag.find_by(name: tag.downcase)
        begin
          #tagsを作成するときに、has_many :tags, through: :group_tagsの記述のおかげで中間テーブルに値が入ってくれる
          self.tags.create!(name: tag)
        rescue
          nil
        end
      else
        #has_many :tags, through: :group_tagsの記述を介してないから、中間テーブルのみ追加。
        GroupTag.create!(group_id: self.id, tag_id: find_tag.id)
      end
    end
  end

  def update_tags(tag_list)
    # 一度既存のGroupTag(このグループに紐づいたもののみ)は削除する(インスタンスメソッド。self.が省略されている。)
    group_tags.map(&:destroy)
    #tagが空であればこのメソッドを抜ける。(空に更新される)
    return unless tag_list
    tag_list.each do |tag|
      # タグが存在しなかったらTagの作成(存在していればfind_or_create_byでは何もしない。)とGroupTagの作成,タグがすでに存在していたらGroupTagの作成
      tag_update = Tag.find_or_create_by(name: tag)#この行では、Tagモデルに一つtagのnameを作成するだけなので、中間テーブルは作成していない。
      # 中間tableの作成
      GroupTag.create!(tag: tag_update, group: self)
    end
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

  def avg_score
    unless self.reviews.empty?
      reviews.average(:score).round(1).to_f
    else
      0.0
    end
  end

  def review_score_percentage
    unless self.reviews.empty?
      reviews.average(:score).round(1).to_f*100/5
    else
      0.0
    end
  end
end
