class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_BOT_SECRET"]
      config.channel_token = ENV["LINE_ACCESS_TOKEN"]
    }
  end

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
        end
      end
      #応答メッセージを送る
      client.reply_message(event['replyToken'], message)
    end
    head :ok
  end

  def notice
    @user = User.find(current_user.id)
    @notifications = current_user.passive_notifications
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    case @notifications
    when @notifications.count += 1
      notification == @notifications.last
      res_uri = URI.parse("https://api.line.me/v2/bot/message/push")
      req = Net::HTTP::Post.new(res_uri.path)
      req.content_type = "application/x-www-form-urlencoded"
      req.authorization = "Bearer #{LINE_ACCESS_TOKEN}"
      req.set_form_data(:to => "#{@user.line_id}",
                        :messages => (:type => "text",
                                      :text => notification_form(notification))
                        )
      req_options = {
        use_ssl: res_uri.scheme == "https"
      }
      response = Net::HTTP.start(res_uri.hostname, res_uri.port, req_options) do |http|
        http.request(req)
      end
    end

    head :ok
  end

  
end
