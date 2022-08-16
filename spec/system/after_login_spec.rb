require 'rails_helper'

describe 'ユーザーログイン後のテスト' do
  #letは、userが出てきた時にuserを生み出す
  let(:user) { create(:user, :user_with_groups) } #:user_with_groups factories/user.rbに記述
  #let!は、itが出てきた時に初めてpostなどを生み出す。
  #letやlet!は、factory_botの機能なので、factoryやmodelsのディレクトリを必ず作成。
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }
  #let(:user) { create(:user, :user_with_groups) }で、group(id: 1)は作成してるから、ここでgroupをcreateすると、group(id: 2)が作成されてしまう。
  let!(:group) { Group.first }
  # let!(:group) { create(:group) } これだと5行目に続いて、id: 2のgroupが生じてしまう
  # let!(:group) { create(:group, name: 'hoge', introduction: 'hoge') }
  let!(:announcement) { create(:announcement, user_id: user.id) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認' do
      it 'マイページを押すと、自分のユーザ詳細画面に遷移する' do
        mypage_link = find_all('a')[2].native.inner_text
        click_link mypage_link
        expect(current_path).to eq('/users/' + user.id.to_s)
      end

      it '投稿一覧を押すと、投稿一覧画面に遷移する' do
        posts_link = find_all('a')[3].native.inner_text
        click_link posts_link
        expect(current_path).to eq('/posts')
      end

      it 'コミュニティ一覧を押すと、コミュニティ一覧画面に遷移する' do
        groups_link = find_all('a')[4].native.inner_text
        click_link groups_link
        expect(current_path).to eq('/groups')
      end

      it '会員一覧を押すと、会員一覧画面に遷移する' do
        users_link = find_all('a')[5].native.inner_text
        click_link users_link
        expect(current_path).to eq('/users')
      end
    end
  end

  describe '自分のマイページのテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '投稿一覧に自分の投稿のtitleが表示され、リンクが正しい' do
        expect(page).to have_link post.title, href: post_path(post)
      end
      it '投稿一覧に自分の投稿のbodyが表示される' do
        expect(page).to have_content post.body
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: user_path(other_user)
        expect(page).not_to have_content other_post.title
        expect(page).not_to have_content other_post.body
      end
    end

    context 'サイドバーの確認' do
      it '自分の名前と紹介文と趣味が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
        expect(page).to have_content user.hobby
      end
      it '自分のユーザ編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_user_path(user)
      end
      it '新規コミュニティ作成画面へのリンクが存在する' do
        expect(page).to have_link '', href: new_group_path
      end
      it '新規投稿画面へのリンクが存在する' do
        expect(page).to have_link '', href: new_post_path
      end
      it '自分がいいねした投稿一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: favorites_user_path(user)
      end
      it '自分が参加中のコミュニティ一覧が表示される' do
        #GroupUser.create(group_id: Group.first.id, user_id: user.id)
        #visit user_path(user)

        #13行目でgroupをcreateした場合(id: 2のgroupが作成されている)
        #id: 1のgroupを指定してやる!!
        #first_group = Group.first
        #expect(page).to have_link first_group.name, href: group_path(group.first)
        #byebugで、考えられうるデータを全て見ていく!!
        # byebug
        expect(page).to have_link group.name, href: group_path(group)

        # expect(page).to have_content user.groups.users.count
      end
      it '自分の朝活宣言が表示される' do
        expect(page).to have_link announcement.announcement, href: edit_user_announcement_path(user, announcement)
      end
    end
  end

end