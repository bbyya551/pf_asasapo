require 'rails_helper'

describe 'コミュニティ一覧画面のテスト' do
  let(:user) { create(:user) }
  let!(:group) { create(:group, :group_with_users) }
  let!(:other_group) { create(:group, :group_with_users) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'コミュニティ一覧画面のテスト' do
    before do
      visit groups_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups'
      end

      it 'コミュニティ名のリンク先がそれぞれ正しい' do
        # byebug
        # let(:group) { create(:group, :group_with_users) }にしていたせいで、itの時にgroupが作られていなかった。
        expect(page).to have_link group.name, href: group_path(group)
        expect(page).to have_link other_group.name, href: group_path(other_group)
      end

      it 'コミュニティに参加中のメンバーの人数が表示される' do
        expect(page).to have_content group.group_users.count
        expect(page).to have_content other_group.group_users.count
      end
    end
  end
end


