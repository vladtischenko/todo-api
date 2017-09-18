# frozen_string_literal: true

class CreateBoards < ActiveRecord::Migration[5.1]
  def change
    create_table :boards do |t|
      t.references :user, foreign_key: true
      t.integer    :tasks_count
      t.string     :name
      t.timestamps
    end
  end
end
