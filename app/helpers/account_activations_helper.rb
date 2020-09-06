require 'sendgrid-ruby'
include SendGrid

module AccountActivationsHelper
  def send_account_velification_mail(user)
    to = SendGrid::Email.new(email: user.email)
    subject = '【アゴラ】アカウント認証メール'
    content = SendGrid::Content.new(
      type: 'text/plain',
      value: 
      if Rails.env.production?
        "
        この度は、「アゴラ」にお申し込み頂きまして
        誠にありがとうございます。

        お申し込み頂きましたアカウント情報は以下となります。

          ログインID：#{user.email}
          パスワード：個人情報のため表示を伏せています

        ご本人様確認のため、下記URLへ「2時間以内」にアクセスし
        アカウントの本登録を完了させて下さい。
        http://agile-inlet-26178.herokuapp.com/account_activations/#{user.activation_token}/edit?email=#{user.email}

          当メール送信後、2時間を超過しますと、セキュリティ保持のため有効期限切れとなります。
          その場合は再度、最初からお手続きをお願い致します。
        "
      else
        "
        この度は、「アゴラ」にお申し込み頂きまして
        誠にありがとうございます。

        お申し込み頂きましたアカウント情報は以下となります。

          ログインID：#{user.email}
          パスワード：個人情報のため表示を伏せています

        ご本人様確認のため、下記URLへ「2時間以内」にアクセスし
        アカウントの本登録を完了させて下さい。
        http://localhost:3000/account_activations/#{user.activation_token}/edit?email=#{user.email}

          当メール送信後、2時間を超過しますと、セキュリティ保持のため有効期限切れとなります。
          その場合は再度、最初からお手続きをお願い致します。
        "
      end
    )
    from = SendGrid::Email.new(email: 'agora.kumamoto@gmail.com')
    mail = SendGrid::Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end
end
