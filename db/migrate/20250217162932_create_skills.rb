# frozen_string_literal: true

class CreateSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :skills do |t|
      t.string :name

      t.timestamps
    end

    add_index :skills, :name, unique: true
  end
end
