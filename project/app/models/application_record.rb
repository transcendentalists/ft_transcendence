class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.position_grade
    {
      "web_owner" => 5, 
      "web_admin" => 4, 
      "owner" => 3, 
      "admin" => 2, 
      "member" => 1,
      "ghost" => 0
    }
  end
end
