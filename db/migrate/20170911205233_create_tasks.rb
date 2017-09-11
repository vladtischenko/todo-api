# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.references :board, foreign_key: true
      t.string     :name
      t.text       :description
      t.integer    :status
      t.timestamps
    end
  end
end
