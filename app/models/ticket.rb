class Ticket < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :status
  belongs_to :user

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 9810 }
  validates :status, presence: true
end
