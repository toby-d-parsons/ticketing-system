class Ticket < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :status

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
end
