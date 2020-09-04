require 'sendgrid-ruby'
include SendGrid

module AccountActivationsHelper
  def send_account_vefification_mail(user)
    to = SendGrid::Email.new(email: user.email)
    subject = '【アゴラ】アカウント認証メール'
    content = SendGrid::Content.new(
      type: 'text/plain',
      value: '

      この度は、「アゴラ」にお申し込み頂きまして
      誠にありがとうございます。

      お申し込み頂きましたアカウント情報は以下となります。

      　ログインID：○○○○○
      　パスワード：個人情報のため表示を伏せています

      ご本人様確認のため、下記URLへ「24時間以内」にアクセスし
      アカウントの本登録を完了させて下さい。
      https://○○○/○○○.aspx?key=Qwertyuioplkjhgfdsazxcvbnm1234567890

      ※当メール送信後、24時間を超過しますと、セキュリティ保持のため有効期限切れとなります。
      　その場合は再度、最初からお手続きをお願い致します。

      ※お使いのメールソフトによってはURLが途中で改行されることがあります。
      　その場合は、最初の「http://」から末尾の英数字までをブラウザに
      　直接コピー＆ペーストしてアクセスしてください。

      ※当メールは送信専用メールアドレスから配信されています。
      　このままご返信いただいてもお答えできませんのでご了承ください。

      ※当メールに心当たりの無い場合は、誠に恐れ入りますが
      　破棄して頂けますよう、よろしくお願い致します。
      '
    )
    from = SendGrid::Email.new(email: 'agora.kumamoto@gmail.com')
    mail = SendGrid::Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end
end
