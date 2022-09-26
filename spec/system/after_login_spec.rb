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
  # エラー解決のためのつけたし
  # let!(:other_group) { create(:other_group, :group_with_users, owner_id: user.id) }
  # let!(:group) { create(:group) } これだと5行目に続いて、id: 2のgroupが生じてしまう
  # let!(:group) { create(:group, name: 'hoge', introduction: 'hoge') }
  let!(:announcement) { create(:announcement, user_id: user.id) }
  #byebugを使ったところ、おそらくbefore呼び出し時点でuserとother_userが作成されている。

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認' do
      it 'マイページを押すと、自分のユーザ詳細画面に遷移する' do
        # mypage_link = find_all('a')[2].native.inner_text
        # click_link mypage_link
        click_link('マイページ')
        expect(current_path).to eq('/users/' + user.id.to_s)
      end

      it '投稿一覧を押すと、投稿一覧画面に遷移する' do
        # posts_link = find_all('a')[4].native.inner_text
        # click_link posts_link
        click_link('投稿一覧')
        expect(current_path).to eq('/posts')
      end

      it 'コミュニティ一覧を押すと、コミュニティ一覧画面に遷移する' do
        # groups_link = find_all('a')[5].native.inner_text
        # click_link groups_link
        click_link('コミュニティ一覧')
        expect(current_path).to eq('/groups')
      end

      it '会員一覧を押すと、会員一覧画面に遷移する' do
        # users_link = find_all('a')[6].native.inner_text
        # click_link users_link
        click_link('会員一覧')
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
        expect(page).to have_content post.body.truncate(10)
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: user_path(other_user)
        expect(page).not_to have_content other_post.title
        expect(page).not_to have_content other_post.body
      end
    end

    context 'サイドバーの確認' do
      it '自分の名前と紹介文と趣味とフォロー中とフォロワーが表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
        expect(page).to have_content user.hobby
        expect(page).to have_link user.followings.count, href: user_followings_path(user)
        expect(page).to have_link user.followers.count, href: user_followers_path(user)
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
        expect(page).to have_content group.users.count

        # expect(page).to have_content user.groups.users.count
      end
      it '自分の朝活宣言が表示される' do
        expect(page).to have_link announcement.announcement, href: edit_user_announcement_path(user, announcement)
      end
      it '朝活宣言作成画面へのリンクが存在する' do
        expect(page).to have_link '', href: new_user_announcement_path(user.id)
      end
    end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it '趣味編集フォームに自分の趣味が表示される' do
        expect(page).to have_field 'user[hobby]', with: user.hobby
      end
      it '更新するボタンが表示される' do
        expect(page).to have_button '更新する'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_introduction = user.introduction
        @user_old_hobby = user.hobby
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 11)
        fill_in 'user[hobby]', with: Faker::Lorem.characters(number: 9)
        expect(user.profile_image).to be_attached
        click_button '更新する'
        save_page
      end

      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'introductionが正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_introduction
      end
      it 'hobbyが正しく更新される' do
        expect(user.reload.hobby).not_to eq @user_old_hobby
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end

  describe '新規グループ作成画面のテスト' do
    before do
      # user = User.first #ここまではuserのidは2できていたけど、id = 1に指定もできる。
      visit new_group_path
      # byebug
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups/' + 'new'
      end
      it 'コミュニティ名フォームが表示される' do
        expect(page).to have_field 'group[name]'
      end
      it 'コミュニティ名フォームに値が入っていない' do
        expect(find_field('group[name]').text).to be_blank
      end
      it 'コミュニティ紹介フォームが表示される' do
        expect(page).to have_field 'group[introduction]'
      end
      it 'コミュニティ紹介フォームに値が入っていない' do
        expect(find_field('group[introduction]').text).to be_blank
      end
      it '画像コミュニティ画像投稿フォームが表示される' do
        expect(page).to have_field 'group[image]'
      end
      it '登録するボタンが表示される' do
        expect(page).to have_button '登録する'
      end
    end

    context '登録成功のテスト' do
      before do
        fill_in 'group[name]', with: Faker::Lorem.characters(number: 5)
        fill_in 'group[introduction]', with: Faker::Lorem.characters(number: 20)
        expect(group.image).to be_attached
        # click_button '登録する'
      end

      it '新しいコミュニティが正しく保存される' do
        # expect { click_button '登録する' }.to change(Group.count, :count).by(1)
        expect { click_button '登録する' }.to change{Group.count}.by(1)
        # byebug
      end

      it 'リダイレクト先が、保存できたコミュニティの詳細画面になっている' do
        click_button '登録する'
        expect(current_path).to eq '/groups/' + Group.last.id.to_s
      end
    end
  end

  describe '新規投稿画面のテスト' do
    before do
      # user = User.first #ここまではuserのidは2できていたけど、id = 1に指定もできる。
      visit new_post_path
      # byebug
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + 'new'
      end
      it '投稿タイトルフォームが表示される' do
        expect(page).to have_field 'post[title]'
      end
      it '投稿タイトルフォームに値が入っていない' do
        expect(find_field('post[title]').text).to be_blank
      end
      it '投稿ジャンルフォームが表示される' do
        expect(page).to have_field 'post[genre_name]'
      end
      it '投稿ジャンルフォームに値が入っていない' do
        expect(find_field('post[genre_name]').text).to be_blank
      end
      it '投稿本文フォームが表示される' do
        expect(page).to have_field 'post[body]'
      end
      it '投稿本文フォームに値が入っていない' do
        expect(find_field('post[body]').text).to be_blank
      end
      it '画像投稿フォームが表示される' do
        expect(page).to have_field 'post[post_image]'
      end
      it '投稿するボタンが表示される' do
        expect(page).to have_button '投稿する'
      end
    end

    context '登録成功のテスト' do
      before do
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 5)
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 20)
        fill_in 'post[genre_name]', with: Faker::Lorem.characters(number: 5)
        expect(post.post_image).to be_attached
      end

      it '新しい投稿が正しく保存される' do
        # expect { click_button '登録する' }.to change(Group.count, :count).by(1)
        expect { click_button '投稿する' }.to change{Post.count}.by(1)
        # byebug
      end

      it 'リダイレクト先が、保存できたコミュニティの詳細画面になっている' do
        click_button '投稿する'
        expect(current_path).to eq '/posts/' + Post.last.id.to_s
      end
    end
  end

  describe '自分がいいねした投稿一覧画面のテスト' do
    before do
      visit favorites_user_path(user)
    end
    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/favorites'
      end
    end
  end

  describe '朝活宣言画面のテスト' do
    before do
      # user = User.first #ここまではuserのidは2できていたけど、id = 1に指定もできる。
      visit new_user_announcement_path(user.id)
      # byebug
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/announcements' + '/new'
      end
      it '朝活宣言フォームが表示される' do
        expect(page).to have_field 'announcement[announcement]'
      end
      it '朝活宣言フォームに値が入っていない' do
        expect(find_field('announcement[announcement]').text).to be_blank
      end
      it '宣言達成ステータスが表示され、未達成がチェックされていて、達成が表示されている' do
        # expect(page).to have_checked_field 'announcement[achieve_status]'
        # expect(page).to have_checked_field 'announcement[nonachieve]'
        # view側(new.html.erb)のlabelでvalueを指定したことで、この記述が可能になる。
        expect(page).to have_checked_field('未達成')
        expect(page).to have_field('達成')
        # expect(page).to have_field '達成'
        # expect(page).to have_checked_field '未達成'
      end
      # it '宣言達成ステータスに未達成が選択されている' do
      #   expect(page).to have_checked_field '未達成', disabled: true
      # end
      it '宣言するボタンが表示される' do
        expect(page).to have_button '宣言する'
      end
    end

    context '登録成功のテスト' do
      before do
        fill_in 'announcement[announcement]', with: Faker::Lorem.characters(number: 5)
        # find('label[for=announcement_achieve_status_nonachieve]').click
        #未達成のラジオボタンを選択して、ページに未達成が表示されるか
        choose "announcement_achieve_status_nonachieve" #announcement_achieve_status_nonachieveは、検証ツールの「未達成」のlabel forの値
        expect(page).to have_checked_field('未達成')
        # choose 'announcement[achieve_status]'
      end

      it '新しい朝活宣言が正しく保存される' do
        # expect { click_button '登録する' }.to change(Group.count, :count).by(1)
        expect { click_button '宣言する' }.to change{Announcement.count}.by(1)
        # byebug
      end

      it 'リダイレクト先が、ユーザーの詳細画面になっている' do
        click_button '宣言する'
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end


  describe '自分の朝活編集画面のテスト' do
    before do
      visit edit_user_announcement_path(user.id, announcement.id)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/announcements/' + announcement.id.to_s + '/edit'
      end
      it '朝活宣言フォームに朝活内容が表示される' do
        expect(page).to have_field 'announcement[announcement]', with: announcement.announcement
      end
      it '朝活達成ステータスで未達成が選択されている' do
        expect(page).to have_checked_field('未達成')
        expect(page).to have_field('達成')
      end
      it '更新するボタンが表示される' do
        expect(page).to have_button '更新する'
      end
      it '削除するが表示される' do
        expect(page).to have_link '削除する', href: user_announcement_path(user.id, announcement.id)
      end
    end

    context '朝活更新成功のテスト' do
      before do
        @announcement_old_announcement = announcement.announcement
        @announcement_old_achieve_status = announcement.achieve_status
        fill_in 'announcement[announcement]', with: Faker::Lorem.characters(number: 7)
        choose "announcement_achieve_status_achieve" #announcement_achieve_status_achieveは、検証ツールの「未達成」のlabel forの値
        expect(page).to have_checked_field('達成')
        click_button '更新する'
        save_page
      end

      it 'announcementが正しく更新される' do
        expect(announcement.reload.announcement).not_to eq @announcement_old_announcement
      end
      it 'achieve_statusが正しく更新される' do
        expect(announcement.reload.achieve_status).not_to eq  @announcement_old_achieve_status
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      # byebug
    end

    context '削除するリンクのテスト' do
      before do
        visit edit_user_announcement_path(user.id, announcement.id)
        # byebug ここではAnnouncement.all、一件ある。
        click_link '削除する'
        # byebug
      end

      it '正しく削除される' do
        # byebug
        # click_link 'delete'
        expect(Announcement.all).to eq []
      end

      it 'リダイレクト先が、ユーザー詳細ページになっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
end