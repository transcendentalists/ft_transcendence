class Match < ApplicationRecord
  belongs_to :rule
  belongs_to :eventable, polymorphic: true
  has_many :scorecards
end
