# frozen_string_literal: true

class CreateChildObjects < ActiveRecord::Migration[6.0]
  def change
    create_table :child_objects do |t|
      t.string :label

      t.timestamps
    end
  end
end
