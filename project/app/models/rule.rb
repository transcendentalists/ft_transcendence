class Rule < ApplicationRecord
  has_many :matches
  has_many :war_requests
  has_many :tournaments
end
