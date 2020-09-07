class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_ACCESS_TOKEN"]
    }
  end

  def callback
    logger.debug('/callback')
    body = request.body.read
    logger.debug(body)
    logger.debug('XXXXXXXXXXXX')
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    logger.debug('YYYYYYYYYYYY')
    unless client.validate_signature(body, signature)
      head :bad_request
    end
    logger.debug('AAAAAAAAAAAA')
    events = client.parse_events_from(body)
    logger.debug('BBBBBBBBBBBB')
    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          logger.debug(message)
        end
      end
    }
    logger.debug('CCCCCCCCCCC')
    head :ok
  end
end
