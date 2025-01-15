class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :user

  validates :content, presence: true, length: { maximum: 9810 }
end
