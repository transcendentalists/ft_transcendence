module Api::DirectChatRoomsHelper
  def get_symbol(user_id_one, user_id_two)
    [user_id_one.to_i, user_id_two.to_i].sort.join('+')
  end
end
