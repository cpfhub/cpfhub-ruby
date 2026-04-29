require 'faraday'
require 'faraday/retry'
require 'json'

module CPFHub
  class Client
    BASE_URL = 'https://api.cpfhub.io/v1'

    def initialize(api_key:)
      @api_key = api_key
      @connection = Faraday.new(url: BASE_URL) do |f|
        f.request :retry, max: 3, interval: 0.5
        f.headers['Authorization'] = "Bearer #{@api_key}"
        f.headers['Content-Type'] = 'application/json'
        f.headers['User-Agent'] = "CPFHub-Ruby-SDK/#{CPFHub::VERSION}"
        f.adapter Faraday.default_adapter
      end
    end

    def lookup(cpf)
      clean_cpf = cpf.to_s.gsub(/\D/, '')
      response = @connection.get("cpf/#{clean_cpf}")
      
      handle_response(response)
    end

    private

    def handle_response(response)
      case response.status
      when 200
        JSON.parse(response.body)
      when 400
        raise Error, "Invalid CPF format"
      when 401
        raise Error, "Invalid or missing API key"
      when 404
        raise Error, "CPF not found"
      when 429
        raise Error, "Rate limit exceeded"
      else
        raise Error, "Server error: #{response.status}"
      end
    end
  end

  class Error < StandardError; end
end
