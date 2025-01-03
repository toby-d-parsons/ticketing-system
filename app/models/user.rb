class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :tickets
  belongs_to :role

  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  PASSWORD_REQUIREMENTS = /\A
    (?=.{8,}) # At least 8 characters long
    (?=.*[a-z]) # Contains at least 1 lowercase letter
    (?=.*[A-Z]) # Contains at least 1 uppercase letter
    (?=.*\d) # Contains at least 1 number
    (?=.*[[:^alnum:]]) # Contains at least 1 symbol
  /x

  validates :password, format: { with: PASSWORD_REQUIREMENTS,
                                 message: "must be 8 or more characters, including lower and upper case letters and at least one number and symbol" },
                                 if: :password_digest_changed?
end
