# frozen_string_literal: true

class CreateParentObjects < ActiveRecord::Migration[6.0]
  def change
    create_table :parent_objects do |t|
      t.string :label

      t.timestamps
    end
  end
end
