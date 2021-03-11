class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def position_grade
    {
      "web_owner" => 5, 
      "web_admin" => 4, 
      "owner" => 3, 
      "master" => 3, 
      "admin" => 2,
      "officer" => 2, 
      "member" => 1,
      "user" => 1,
      "ghost" => 0
    }
  end

  def position_compare(membership_one, membership_two)
    position_grade[membership_one.position] - position_grade[membership_two.position]
  end

  def self.group_chat_positions
    ["owner", "admin", "member"]
  end

  def self.guild_positions
    ["master", "officer", "member"]
  end

  def self.user_positions
    ["web_owner", "web_admin", "user"]
  end

end
