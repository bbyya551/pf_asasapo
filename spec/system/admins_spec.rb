require 'rails_helper'

describe '管理者ログイン後のテスト' do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }
  let!(:group) { create(:group) }
  let!(:other_group) { create(:group) }
  let!(:post_comment) { create(:post_comment, post: post, user: user) }

  before do
    visit new_admin_session_path
    fill_in 'admin[email]', with: admin.email
    fill_in 'admin[password]', with: admin.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト : ログインしている場合' do
    context 'リンクの内容を確認' do
      it '投稿一覧を押すと、投稿一覧画面に遷移する' do
        click_link("投稿一覧")
        expect(current_path).to eq('/admin/posts')
        # posts_link = find_all('a')[1].native.inner_text
        # click_link posts_link
        # expect(current_path).to eq('/admin/posts')
      end

      it 'コミュニティ一覧を押すと、コミュニティ一覧画面に遷移する' do
        click_link('コミュニティ一覧')
        expect(current_path).to eq('/admin/groups')
      end

      it '会員一覧を押すと、会員一覧画面に遷移する' do
        click_link('会員一覧')
        expect(current_path).to eq('/admin/users')
      end

      it '通報一覧を押すと、通報一覧画面に遷移する' do
        click_link('通報一覧')
        expect(current_path).to eq('/admin/reports')
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit admin_posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/posts'
      end

      it '投稿のタイトルのリンク先がそれぞれ正しい' do
        expect(page).to have_link post.title, href: admin_post_path(post.id)
        expect(page).to have_link other_post.title, href: admin_post_path(other_post.id)
      end

      it '投稿の本文が表示される' do
        expect(page).to have_content post.body.truncate(10)
        expect(page).to have_content other_post.body.truncate(10)
      end

      it '投稿に、投稿日が表示される' do
        expect(page).to have_content post.created_at.strftime('%Y/%m/%d')
        expect(page).to have_content other_post.created_at.strftime('%Y/%m/%d')
      end

      it '投稿に、コメント数が表示される' do
        expect(page).to have_content post.post_comments.count
        expect(page).to have_content other_post.post_comments.count
      end
    end
  end

  describe '投稿詳細画面のテスト' do
    before do
      visit admin_post_path(post.id)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/' + 'posts/' + post.id.to_s
      end
      it '投稿詳細と表示される' do
        expect(page).to have_content '投稿詳細'
      end
      it 'ユーザー名のリンク先が正しい' do
        expect(page).to have_link post.user.name, href: admin_user_path(post.user)
      end
      it '投稿のタイトルが表示される' do
        expect(page).to have_content post.title
      end
    end
  end
end