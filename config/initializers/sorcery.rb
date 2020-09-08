Rails.application.config.sorcery.submodules = [:external]

Rails.application.config.sorcery.configure do |config|
  
  config.external_providers = [:line]

  config.line.key = ENV["LINE_LOGIN_KEY"]
  config.line.secret = ENV["LINE_LOGIN_SECRET"]
  config.line.callback_url = ENV["LINE_CALLBACK"]
  config.line.scope = 'openid'
 
end