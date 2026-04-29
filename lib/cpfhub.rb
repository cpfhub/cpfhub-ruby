require_relative 'cpfhub/version'
require_relative 'cpfhub/client'

module CPFHub
  def self.new(api_key:)
    Client.new(api_key: api_key)
  end
end
