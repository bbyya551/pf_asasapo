require 'rails_helper'

describe 'ユーザー一覧画面のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'ユーザー一覧画面のテスト' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users'
      end
      it '自分と他人の画像が表示される: 画像がヘッダーの一つ + サイドバーの1つ＋一覧(2人)の2つの計3つ存在する' do
        expect(all('img').size).to eq(4)
      end

      it '自分と他人の名前がそれぞれ表示され、遷移先が正しい' do
        expect(page).to have_content user.name
        expect(page).to have_content other_user.name
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_link other_user.name, href: user_path(other_user)
      end

      # it '自分と他人のshowリンクがそれぞれ表示される' do
      #   expect(page).to have_link 'Show', href: user_path(user)
      #   expect(page).to have_link 'Show', href: user_path(other_user)
      # end
      it '他人の通報リンクが表示される' do
        expect(page).to have_link '通報', href: new_user_report_path(other_user)
      end
    end
  end
end