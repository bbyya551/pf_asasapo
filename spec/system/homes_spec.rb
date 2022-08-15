require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  let!(:user) { create(:user) }
  #postを作るとき、user_idは指定しなくていいですか
  let!(:post) { create(:post, title: 'hoge', body: 'hoge') }
  #groupを作る時、owner_idは指定しなくていいですか
  let!(:group) { create(:group, name: 'hoge', introduction: 'hoge') }

  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end

      it '新着コミュニティの名前のリンク先が新規登録画面である' do
        expect(page).to have_link group.name, href: new_user_registration_path
      end

      it '新着投稿のタイトルのリンク先が新規登録画面である' do
        expect(page).to have_link post.title, href: new_user_registration_path
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it '新規登録リンクが表示される' do
        sign_up_link = find_all('a')[1].native.inner_text
        expect(sign_up_link).to match(/新規登録/)
      end
      it '新規登録リンクの内容が正しい' do
        sign_up_link = find_all('a')[1].native.inner_text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end

      it 'ログインリンクが表示される' do
        log_in_link = find_all('a')[2].native.inner_text
        expect(log_in_link).to match(/ログイン/)
      end
      it 'ログインリンクの内容が正しい' do
        log_in_link = find_all('a')[2].native.inner_text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end

      it '管理者はこちらリンクが表示される' do
        admin_log_in_link = find_all('a')[4].native.inner_text
        expect(admin_log_in_link).to match(/管理者はこちら/)
      end
      it '管理者はこちらリンクの内容が正しい' do
        admin_log_in_link = find_all('a')[4].native.inner_text
        expect(page).to have_link admin_log_in_link, href: new_admin_session_path
      end
    end
  end

  describe 'ユーザー新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「Sign up」と表示される' do
        expect(page).to have_content 'Sign up'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it 'Sign upボタンが表示される' do
        expect(page).to have_button 'Sign up'
      end
    end

     context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button 'Sign up' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザのマイページになっている' do
        click_button 'Sign up'
        expect(current_path).to eq '/users/' + User.last.id.to_s
      end
    end
  end

  describe 'ユーザログインのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ユーザーLog in」と表示される' do
        expect(page).to have_content 'ユーザーLog in'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'Log inボタンが表示される' do
        expect(page).to have_button 'Log in'
      end
      it 'nameフォームは表示されない' do
        expect(page).not_to have_field 'user[name]'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'Log in'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザのマイページになっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'Log in'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
    end

    context 'ヘッダーの表示を確認' do
      it 'マイページリンクが表示される' do
        user_link = find_all('a')[2].native.inner_text
        expect(user_link).to match(/マイページ/)
      end
      it '投稿一覧リンクが表示される' do
        posts_link = find_all('a')[3].native.inner_text
        expect(posts_link).to match(/投稿一覧/)
      end
      it 'コミュニティ一覧リンクが表示される' do
        groups_link = find_all('a')[4].native.inner_text
        expect(groups_link).to match(/コミュニティ一覧/)
      end
      it '会員一覧リンクが表示される' do
        users_link = find_all('a')[5].native.inner_text
        expect(users_link).to match(/会員一覧/)
      end
      it 'ログアウトリンクが表示される' do
        logout_link = find_all('a')[6].native.inner_text
        expect(logout_link).to match(/ログアウト/)
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
      logout_link = find_all('a')[6].native.inner_text
      # logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてログイン画面へのリンクが存在する' do
        expect(page).to have_link "", href: new_user_session_path
      end
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
    end
  end
end