class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :tickets
  belongs_to :role

  validates :email_address, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
