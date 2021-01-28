class Tournament < ApplicationRecord
  belongs_to :rule
  has_many :match, as: :eventable
  has_many :tournament_memberships
end
