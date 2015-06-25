require 'singleton'
require 'mysql2'

class DbAdapter
  include Singleton

  def client
    @client ||= Mysql2::Client.new(
      host: ENV['DB_HOST'],
      username: ENV['DB_USER'],
      database: 'water_sample'
    )
  end
end
