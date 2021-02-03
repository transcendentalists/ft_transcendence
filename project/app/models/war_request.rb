class WarRequest < ApplicationRecord
  belongs_to :rule
  has_one :war
  has_many :war_statuses
end
