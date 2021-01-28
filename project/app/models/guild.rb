class Guild < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :guild_memberships
  has_many :war_statuses
end
