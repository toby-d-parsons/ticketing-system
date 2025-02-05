class Ticket < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :status
  belongs_to :user
  belongs_to :assigned_agent, class_name: "User", foreign_key: "assigned_agent_id", optional: true

  validate :assigned_agent_exists_with_valid_role

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 9810 }
  validates :status, presence: true

  private

  def assigned_agent_exists_with_valid_role
    return if assigned_agent_id.nil? # Allow nil values

    unless User.exists?(id: assigned_agent_id)
      errors.add(:assigned_agent_id, "must be a valid user")
      return
    end

    unless User.find(assigned_agent_id).role.name == "Support Agent"
      errors.add(:assigned_agent_id, "must have the 'Support Agent' role")
    end
  end
end
