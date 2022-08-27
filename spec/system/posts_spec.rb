require 'rails_helper'

describe '投稿一覧画面のテスト' do
  let(:user) { create(:user, :user_with_groups) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, :post_with_genres, user: user) }
  let!(:other_post) { create(:post, :post_with_genres, user: other_user) }
  # 先に1ついいね済にしておく(一覧画面でのいいねのテスト用)
  let!(:favorite) { create(:favorite, post: post, user: user) }
  let!(:genre) { Genre.first }
  let!(:group) { Group.first }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      it '自分の投稿と他人の投稿のタイトルのリンク先がそれぞれ正しい' do
        expect(page).to have_link post.title, href: post_path(post.id)
        expect(page).to have_link other_post.title, href: post_path(other_post.id)
      end

      it '自分の投稿と他人の投稿の本文が表示される' do
        expect(page).to have_content post.body
        expect(page).to have_content other_post.body
      end

      it '自分の投稿と他人の投稿に、投稿した人の名前が表示される' do
        expect(page).to have_content post.user.name
        expect(page).to have_content other_post.user.name
      end

      it '自分の投稿と他人の投稿に、投稿日が表示される' do
        expect(page).to have_content post.created_at.strftime('%Y/%m/%d')
        expect(page).to have_content other_post.created_at.strftime('%Y/%m/%d')
      end

      it '自分の投稿と他人の投稿に、いいね数が表示される' do
        expect(page).to have_content post.favorites.count
        expect(page).to have_content other_post.favorites.count
      end

      it '自分の投稿と他人の投稿に、コメント数が表示される' do
        expect(page).to have_content post.post_comments.count
        expect(page).to have_content other_post.post_comments.count
      end
    end

    context 'いいね確認' do
      it 'リンクと表示が正しい' do
        expect(page).to have_link '', href: post_favorites_path(post.id) #リンクが正しい
        expect(page).to have_css('i.nonfavorite') #いいねの表示
        expect(page).to have_css('i.favorite') #いいね済の表示
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit post_path(post.id)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it '投稿詳細と表示される' do
        expect(page).to have_content '投稿詳細'
      end
      it 'ユーザー名のリンク先が正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
      end
      it '投稿のタイトルが表示される' do
        expect(page).to have_content post.title
      end
      it '投稿の本文が表示される' do
        expect(page).to have_content post.body
      end
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '削除する', href: post_path(post)
      end

      it '投稿に、投稿日が表示される' do
        expect(page).to have_content post.created_at.strftime('%Y/%m/%d')
      end

      it '投稿に、いいね数が表示される' do
        expect(page).to have_content post.favorites.count
      end

      it '投稿に、コメント数が表示される' do
        expect(page).to have_content post.post_comments.count
      end

      it '投稿に、投稿ジャンルが表示される' do
        # byebug
        expect(page).to have_content genre.name
      end

      it 'コメントフォームが表示される' do
        expect(page).to have_field 'post_comment[comment]'
      end
      it 'コメントフォームに値が入っていない' do
        expect(find_field('post_comment[comment]').text).to be_blank
      end
    end

    # context 'いいねをクリックした場合' do
    #   it 'いいねできる' do
    #     # byebug
    #     #GroupUser.create(group_id: Group.first.id, user_id: user.id)
    #     # find('div#post_<%= post.id %> .favorite-btn').click
    #     # expect(find('div#post_<%= post.id %> .favorite-btn').click).to change(Favorite.count).by(1)
    #     # expect(Favorite.create(user_id: user.id, post_id: post.id)).to change(post.favorites.count).by(1)
    #     # find('.nonfavorite').click
    #     # expect(page).to have_css '.favorite'
    #   end
    # end
  end
end