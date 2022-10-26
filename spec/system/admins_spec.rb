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
  end
end