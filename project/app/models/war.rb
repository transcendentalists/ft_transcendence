class War < ApplicationRecord
  belongs_to :war_request
  has_many :match, as: :eventable
end
