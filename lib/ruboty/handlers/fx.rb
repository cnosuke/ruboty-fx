require 'rest-client'

module Ruboty
  module Handlers
    class Fx < Base
      YFX_URL = 'http://info.finance.yahoo.co.jp/fx/async/getRate/'

      on /fx( me)? ?(?<pair>.+)?/, name: 'fx', description: 'Show current currency.'
      on /fx( me)? list/, name: 'list', description: 'List  current currencies.'

      def fx(message = {})
        pair = message[:pair].gsub('/','').gsub(/\s/,'')
        data = JSON.parse( RestClient.post(YFX_URL, nil) || '{}' )

        result_str = data[pair].map{|k,v| "#{k}: #{v}" }.join(', ')
        message.reply("[#{pair.scan(/\w{3}/).join('/')}] #{result_str}")
      rescue
        message.reply('Unknow error.')
      end

      def list(m = {})
      end
    end
  end
end
