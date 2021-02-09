class Guild < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :memberships, class_name: "GuildMembership"
  has_many :war_statuses
  has_many :users, through: :memberships, source: :user

  def to_simple
    permitted = ["id", "name", "anagram"]
    data = self.attributes.filter { |field, value| permitted.include?(field) }
  end
end
