module Sorcery
  module Controller
    module Submodules
      # This submodule helps you login users from external auth providers such as Twitter.
      # This is the controller part which handles the http requests and tokens passed between the app and the @provider.
      module External
        def self.included(base)
          base.send(:include, InstanceMethods)

          require 'sorcery/providers/base'
          require 'sorcery/providers/facebook'
          require 'sorcery/providers/twitter'
          require 'sorcery/providers/vk'
          require 'sorcery/providers/linkedin'
          require 'sorcery/providers/liveid'
          require 'sorcery/providers/xing'
          require 'sorcery/providers/github'
          require 'sorcery/providers/heroku'
          require 'sorcery/providers/google'
          require 'sorcery/providers/jira'
          require 'sorcery/providers/salesforce'
          require 'sorcery/providers/paypal'
          require 'sorcery/providers/slack'
          require 'sorcery/providers/wechat'
          require 'sorcery/providers/microsoft'
          require './lib/monkey_patches/line'

          Config.module_eval do
            class << self
              attr_reader :external_providers
              attr_accessor :ca_file

              def external_providers=(providers)
                @external_providers = providers

                providers.each do |name|
                  class_eval <<-E
                    def self.#{name}
                      @#{name} ||= Sorcery::Providers.const_get('#{name}'.to_s.capitalize).new
                    end
                  E
                end
              end

              def merge_external_defaults!
                @defaults.merge!(:@external_providers => [],
                                 :@ca_file => File.join(File.expand_path(File.dirname(__FILE__)), '../../protocols/certs/ca-bundle.crt'))
              end
            end
            merge_external_defaults!
          end
        end
      end
    end
  end
end