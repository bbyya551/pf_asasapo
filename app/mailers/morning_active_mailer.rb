class MorningActiveMailer < ApplicationMailer
  def check_notice_mail
    #selectは、メソッドの戻り値が真の時に要素を集めた配列を返す。
    #今いるユーザーを一人ずつ調べる。
    users_with_unchecked_notices = User.all.select do |user|
      user.passive_notifications.where(visited_id: user.id, checked: false).count >= 5
    end

    users_with_unchecked_notices_mails = users_with_unchecked_notices.pluck(:email)
    #戻り値をrails cで調べる
    # return users_with_unchecked_notices
    mail(subject: "朝活は順調ですか?", bcc: users_with_unchecked_notices_mails)
  end
end
