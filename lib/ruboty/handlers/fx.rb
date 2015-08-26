require 'rest-client'

module Ruboty
  module Handlers
    class Fx < Base
      YFX_URL = 'http://info.finance.yahoo.co.jp/fx/async/getRate/'

      on /list( me)? fx/, name: 'list', description: 'List  current currencies.'
      on /fx( me)? ?(?<pair>.+)?/, name: 'fx', description: 'Show current currency.'

      def fx(message = {})
        pair = message[:pair].gsub('/','').gsub(/\s/,'')
        message.reply(rate_to_s(get_json[pair], pair))
      rescue
        message.reply('Unknow error.')
      end

      def list(m = {})
        str = get_json.map do |pair, state|
          rate_to_s(state, pair)
        end.join("\n")

        m.reply("```\n#{str}\n```")
      rescue
        m.reply('Unknow error.')
      end

      private

      def get_json
        JSON.parse( RestClient.post(YFX_URL, nil) || '{}' )
      end

      def rate_to_s(state, pair)
        result_str = state.map{|k,v| "#{k}: #{v}" }.join(",\t")
        "[#{pair.scan(/\w{3}/).join('/')}] #{result_str}"
      end
    end
  end
end
