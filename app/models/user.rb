class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  private

    def generate_api_key
      loop do
        self.api_key = SecureRandom.hex(20) # Generates a 40-character string
        break unless User.exists?(api_key: api_key)
      end
    end
end
