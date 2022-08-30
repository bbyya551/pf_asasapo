require 'rails_helper'

describe 'コミュニティ一覧画面のテスト' do
  let(:user) { create(:user) }
  let!(:group) { create(:group, :group_with_users, owner_id: user.id) }
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

      it 'コミュニティのShowリンクが表示される' do
        expect(page).to have_link 'Show', href: group_path(group)
      end

      it 'コミュニティ編集画面へのリンクが表示される' do
        #最初に、 let!(:group) { create(:group, :group_with_users, owner_id: user.id) }で、owner_id: user.idとして、owner_idをログインしているユーザーに指定してやる必要がある!
        expect(page).to have_link '編集', href: edit_group_path(group)
      end
    end
  end
end


