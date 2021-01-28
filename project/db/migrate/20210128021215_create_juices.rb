class CreateJuices < ActiveRecord::Migration[6.1]
  def change
    create_table :juices do |t|
      t.string :name

      t.timestamps
    end
  end
end
