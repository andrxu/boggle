# frozen_string_literal: true

class DictionaryAccessor

  require 'net/http'
  require 'uri'

  SERVER_URL = 'https://www.dictionaryapi.com/api/v3/references/sd3/json/%s?key=ab642038-1474-474c-8eab-8a7483c8aa22'

  def self.query_word(word)
    uri = URI.parse(format(SERVER_URL, word))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)

    { code: response.code, body: response.body }
  end

  def self.word_valid?(word)
    result = query_word(word)
    result[:code] == '200' && result[:body].include?('meta')
  end
end