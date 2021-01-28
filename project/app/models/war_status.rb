class WarStatus < ApplicationRecord
  belongs_to :guild
  belongs_to :war_request
end
