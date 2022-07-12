# frozen_string_literal: true

class CreateStructures < ActiveRecord::Migration[6.0]
  def change
    create_table :structures do |t|
      t.boolean :top_level
      t.text :label

      t.timestamps
    end
  end
end
