class AddEmailAndVerificationCodeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :email, :string, default: "marvin@ecole42.fr", null: false
    add_column :users, :verification_code, :string
  end
end
