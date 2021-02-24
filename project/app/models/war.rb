class War < ApplicationRecord
  belongs_to :request, class_name: "WarRequest", :foreign_key => "war_request_id"
  has_many :matches, as: :eventable
  validates :status, inclusion: { in: ["pending", "progress", "completed"] }
end
