require 'active_record'
require 'active_support/core_ext/logger' rescue nil  # rails3

require 'acts_as_secure'

ActiveRecord::Base.establish_connection({'adapter' => 'sqlite3', 'database' => ':memory:'})
ActiveRecord::Base.logger = Logger.new("#{File.dirname(__FILE__)}/active_record.log")

connection = ActiveRecord::Base.connection

connection.create_table :fruits do |t|
  t.string :name
end

connection.create_table :secret_fruits do |t|
  t.column :name, :binary
  t.column :fruit_id, :integer
end

connection.create_table :uber_secret_fruits do |t|
  t.column :name, :binary
  t.column :fruit_id, :integer
end


class Rot13CryptoProvider
  class << self
    def encrypt(arg)
      arg.tr("A-Za-z", "N-ZA-Mn-za-m")
    end
    alias_method :decrypt, :encrypt
  end
end

class SaltedRot13CryptoProvider
  def initialize(salt)
    @salt = salt
  end
  def encrypt(arg)
    @salt + arg.tr("A-Za-z", "N-ZA-Mn-za-m")
  end
  def decrypt(arg)
    arg[@salt.size .. -1].tr("A-Za-z", "N-ZA-Mn-za-m")
  end
end


class Fruit < ActiveRecord::Base
    has_one :secret_fruit
    has_one :uber_secret_fruit
end

class SecretFruit < ActiveRecord::Base
  acts_as_secure :crypto_provider => Rot13CryptoProvider
  belongs_to :fruit
end

class UberSecretFruit < ActiveRecord::Base
  acts_as_secure
  belongs_to :fruit
end