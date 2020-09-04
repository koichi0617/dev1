class ApplicationMailer < ActionMailer::Base
  default from: 'agora管理者' #メールの送り主
  layout 'mailer'
end
