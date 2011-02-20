require 'test_in_memory'

describe "acts_as_secure" do
  it "should make sure README works" do
    f = Fruit.create(:name => 'passion fruit')
    SecretFruit.create(:name => 'maracuya', :fruit => f)
    f.secret_fruit.name.should eql('maracuya')

    secret = 'uber_secret'
    crypto_provider = SaltedRot13CryptoProvider.new(secret)
    UberSecretFruit.with_crypto_provider(crypto_provider) { UberSecretFruit.create(:name => 'Passiflora edulis', :fruit => f) }
    UberSecretFruit.with_crypto_provider(crypto_provider) { f.uber_secret_fruit.name.should eql('Passiflora edulis') }
  end

  it "should allow you to read attributes before encryption" do
    f = Fruit.create(:name => 'passion fruit')
    SecretFruit.create(:name => 'maracuya', :fruit => f)

    f.secret_fruit.read_attribute_before_decryption(:name).should eql('znenphln'.to_yaml)
    f.secret_fruit.name.should eql('maracuya')
  end

  it "should encrypt properly" do
    f = Fruit.create(:name => 'passion fruit')
    SecretFruit.create(:name => 'maracuya', :fruit => f)

    f.secret_fruit.read_attribute_before_decryption(:name).should eql(f.secret_fruit.send(:secure_encrypt, 'maracuya'))
  end

  it "should test secure columns" do
    SecretFruit.secure_columns.map(&:name).should_not include('id')
    SecretFruit.secure_columns.map(&:name).should_not include('fruit_id')
    SecretFruit.secure_columns.map(&:name).should include('name')
  end

  it "should test except" do
    class SecretFruit < ActiveRecord::Base
      acts_as_secure :crypto_provider => Rot13CryptoProvider, :except => [:name]
      belongs_to :fruit
    end

    SecretFruit.secure_columns.should be_blank
  end

  it "should allow the storage type to be selected" do
    class SecretFruit < ActiveRecord::Base
      acts_as_secure :crypto_provider => Rot13CryptoProvider, :storage_type => :integer
      belongs_to :fruit
    end

    SecretFruit.secure_columns.map(&:name).should include('id')
    SecretFruit.secure_columns.map(&:name).should include('fruit_id')
    SecretFruit.secure_columns.map(&:name).should_not include('name')
  end
end
