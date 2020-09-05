class Mail::SendGrid
  def initialize(settings)
    @settings = settings
  end

  def deliver!(mail)
    to = SendGrid::Email.new(email: mail.to.first)
    subject = mail.subject
    sg_mail = SendGrid::Mail.new(subject, to)

    sg = SendGrid::API.new(api_key: @settings[:api_key])
    response = sg.client.mail._('send').post(request_body: sg_mail.to_json)
    puts response.status_code
  end
end