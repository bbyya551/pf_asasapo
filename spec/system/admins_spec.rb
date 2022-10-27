require 'rails_helper'

describe '管理者ログイン後のテスト' do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post) }
  let!(:other_post) { create(:post) }
  let!(:group) { create(:group) }
  let!(:other_group) { create(:group) }

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
end