class Comment < ApplicationRecord
  belongs_to :ticket

  validates :content, presence: true, length: { maximum: 9810 }
end
