class DirectChatRoom < ApplicationRecord
  has_many :messages, class_name: "ChatMessage", as: :room
  has_many :memberships, class_name: "DirectChatMembership"
  has_many :users, through: :memberships, source: :user

  validates :symbol, uniqueness: true

  def create_memberships_by_ids!(id_one, id_two)
    raise ServiceError.new if !User.exists?(id_one) || !User.exists?(id_two)
    self.memberships.create!([{user_id: id_one}, {user_id: id_two}])
  end
end
