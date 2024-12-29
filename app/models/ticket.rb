class Ticket < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :status
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
end
