class Post < ApplicationRecord
  has_one_attached :post_image

  def get_post_image(width, height)
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image_tate.jpeg')
      post_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
      # post_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    post_image.variant(resize_to_limit: [width, height]).processed
  end
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_genres, dependent: :destroy
  has_many :genres, through: :post_genres

  has_many :notifications, dependent: :destroy

  # validates :title, presence:true
  # validates :body, presence:true,length:{maximum: 180}

  validates :title, presence:true
  validates :body, presence:true,length:{maximum: 200}

  enum status: { public: 0, private: 1 }, _prefix: true

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.search_for(content, method)
    if method == 'perfect'
      Post.status_public.where(title: content)
    elsif method == 'forward'
      Post.status_public.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Post.status_public.where('title LIKE ?', '%'+content)
    else
      Post.status_public.where('title LIKE ?', '%'+content+'%')
    end
  end

  # postsコントローラで配列化した値を引数で受け取る
  # binding.pry
  def save_genres(genre_list)
    genre_list.each do |genre|
      # 受け取った値を小文字に変換して、DBを検索して存在しない場合は
      # find_genreに nil が代入され　nil となるのでgenreの作成開始
      unless find_genre = Genre.find_by(name: genre.downcase)
        begin
          # create メソッドでgenreの作成
          # create! としているのは、保存が成功しても失敗してもオブジェクト
          # を返してしまうため、例外を発生させたい
          self.genres.create!(name: genre)

          # 例外が発生すると rescue 内の処理が走り nil になる
          # 値は保存されず次の処理へ
        rescue
          nil
        end
      else
        # find_genreでDB にgenreが存在した場合、中間テーブルにpostとgenreを紐付けている
        PostGenre.create!(post_id: self.id, genre_id: find_genre.id)
      end
    end
  end

  def update_genres(genre_list)
    post_genres.map(&:destroy)
    return unless genre_list
    genre_list.each do |genre|
      genre = Genre.find_or_create_by(name: genre)
      PostGenre.create!(genre: genre, post: self)
    end
  end

  def create_notification_like!(current_user)
    #この行(temp)そのままrails console打とう
    #インスタンスメソッド user_idはPost自身のuser_idのこと。idはPost自身のidのこと。
    #非同期でうまくいかない時はターミナルをみよう
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'Like'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'Like'
      )

      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_user, post_comment_id)
    #インスタンスメソッド(post_id: id)は、PostCommentのpost_idは、このPostモデル自身のidという意味。(post: selfでもいける。)
    temp_ids = PostComment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, post_comment_id, temp_id['user_id']) #ここのuser_idは、コメントのuser_id
    end
    save_notification_comment!(current_user, post_comment_id, user_id) if temp_ids.blank? #ここのuser_idは、投稿自体のuser_id
  end

  def save_notification_comment!(current_user, post_comment_id, visited_id)
    notification = current_user.active_notifications.new(
      post_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
