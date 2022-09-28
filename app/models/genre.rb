class Genre < ApplicationRecord
  before_save :downcase_genre_name
  has_many :post_genres, dependent: :destroy, foreign_key: 'genre_id'
  has_many :posts, through: :post_genres
  validates :name, uniqueness: true, length: { maximum: 30 }

  def self.search_posts_for(content, method)

    if method == 'perfect'
      genres = Genre.where(name: content)
    elsif method == 'forward'
      genres = Genre.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      genres = Genre.where('name LIKE ?', '%' + content)
    elsif method == 'partial'
      genres = Genre.where('name LIKE ?', '%' + content + '%')
    end

    return genres.inject(init = []) {|result, genre| result + genre.posts.status_public}
    #レシーバのgenresには上で取得したgenresが配列で入っている。
    #ここでinjectの引数は空なのでまず空がresultに入る。
    # =begin
    # =>''(injectの初期値)
    # =>genre.posts（初期値（result, ''）+配列の最初の要素（genre）に紐づいたpostsの合計）
    # =>genre.posts + genre.posts （前回の処理の戻り値（genre.posts）がsumに入る+二番目の要素（genre.posts）の合計）
    # =>genre.posts + genre.posts + genre.posts  （以下略）
    # =>genre.posts + genre.posts + genre.posts ...(全体の戻り値)
    # =end
  end

  private
    def downcase_genre_name
      self.name.downcase!
    end
end
