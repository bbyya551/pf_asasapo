require 'rails_helper'

describe 'コミュニティ一覧画面のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
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

      it '自分がオーナーのコミュニティの場合、コミュニティ編集画面へのリンクが表示される' do
        #最初に、 let!(:group) { create(:group, :group_with_users, owner_id: user.id) }で、owner_id: user.idとして、owner_idをログインしているユーザーに指定してやる必要がある!
        expect(page).to have_link '編集', href: edit_group_path(group)
      end
    end
  end

  describe 'コミュニティ詳細画面のテスト(自分がコミュニティのオーナーの時)' do
    before do
      visit group_path(group.id)
      @owner = User.find(group.owner_id)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups/' + group.id.to_s
      end

      it 'コミュニティ詳細ページと表示される' do
        expect(page).to have_content 'コミュニティ詳細ページ'
      end

      it 'コミュニティの名前が表示される' do
        expect(page).to have_content group.name
      end

      it 'コミュニティの説明が表示される' do
        expect(page).to have_content group.introduction
      end

      it '編集が表示され、リンク先が正しい' do
        expect(page).to have_link '編集', href: edit_group_path(group)
      end

      it '朝活を開催が表示され、リンク先が正しい' do
        expect(page).to have_link '朝活を開催', href: group_new_mail_path(group.id)
      end

      it 'コミュニティオーナー名のリンク先が正しい' do
        expect(page).to have_link @owner.name, href: user_path(@owner)
      end

      it 'コミュニティメンバーが一覧で表示され、リンク先が正しい' do
        group.users.each do |user|
          expect(page).to have_link user.name, href: user_path(user.id)
        end
      end
    end
  end

  describe 'コミュニティ詳細画面のテスト(自分がコミュニティのオーナーではない時)' do
    before do
      logout_link = find_all('a')[6].native.inner_text
      click_link logout_link
      expect(current_path).to eq('/')
      visit new_user_session_path
      fill_in 'user[email]', with: other_user.email
      fill_in 'user[password]', with: other_user.password
      click_button 'Log in'
      # byebug
      visit group_path(group.id)
      @owner = User.find(group.owner_id)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups/' + group.id.to_s
      end

      it 'コミュニティ詳細ページと表示される' do
        expect(page).to have_content 'コミュニティ詳細ページ'
      end

      it 'コミュニティの名前が表示される' do
        expect(page).to have_content group.name
      end

      it 'コミュニティの説明が表示される' do
        expect(page).to have_content group.introduction
      end

      it 'コミュニティオーナー名のリンク先が正しい' do
        expect(page).to have_link @owner.name, href: user_path(@owner)
      end

      it 'このコミュニティに参加が表示され、リンク先が正しい' do
        expect(page).to have_link 'このコミュニティに参加', href: group_group_users_path(group.id)
        # byebug
      end

      it 'コミュニティメンバーが一覧で表示され、リンク先が正しい' do
        group.users.each do |user|
          expect(page).to have_link user.name, href: user_path(user.id)
        end
      end
    end
  end

  describe 'コミュニティ詳細画面のテスト(自分がコミュニティのオーナーではなくて、すでにメンバーである時)' do
    before do
      logout_link = find_all('a')[6].native.inner_text
      click_link logout_link
      expect(current_path).to eq('/')
      # user = group.users[0]
      # byebug
      #すでにグループに存在しているメンバーgroup.users[0]でログインする必要がある
      visit new_user_session_path
      fill_in 'user[email]', with: group.users[0].email
      fill_in 'user[password]', with: group.users[0].password
      click_button 'Log in'
      #最初、visit new_user_session_pathの前にuser = User.find(3)と定義してログインしようとしたところ、ログインがそもそもできていなかった。
      # byebug
      visit group_path(group.id)
      @owner = User.find(group.owner_id)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups/' + group.id.to_s
      end

      it 'コミュニティ詳細ページと表示される' do
        expect(page).to have_content 'コミュニティ詳細ページ'
      end

      it 'コミュニティの名前が表示される' do
        expect(page).to have_content group.name
      end

      it 'コミュニティの説明が表示される' do
        expect(page).to have_content group.introduction
      end

      it 'コミュニティオーナー名のリンク先が正しい' do
        expect(page).to have_link @owner.name, href: user_path(@owner)
      end

      it 'コミュニティから脱退が表示され、リンク先が正しい' do
        expect(page).to have_link 'コミュニティから脱退', href: group_group_users_path(group.id)
      end

      it 'コミュニティメンバーが一覧で表示され、リンク先が正しい' do
        group.users.each do |user|
          expect(page).to have_link user.name, href: user_path(user.id)
        end
      end
    end
  end
end


