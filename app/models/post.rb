class Post < ApplicationRecord
  has_one_attached :post_image

  def get_post_image(width, height)
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      post_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    post_image.variant(resize_to_limit: [width, height]).processed
  end
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_genres, dependent: :destroy
  has_many :genres, through: :post_genres

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.search_for(content, method)
    if method == 'perfect'
      Post.where(title: content)
    elsif method == 'forward'
      Post.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Post.where('title LIKE ?', '%'+content)
    else
      Post.where('title LIKE ?', '%'+content+'%')
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
end
