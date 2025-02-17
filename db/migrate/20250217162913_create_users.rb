class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :surname, null: false
      t.string :name, null: false
      t.string :patronymic, null: false
      t.string :email, null: false
      t.integer :age, null: false
      t.string :gender, null: false
      t.string :nationality, null: false
      t.string :country, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end