# frozen_string_literal: true

class AddObjectsToStructure < ActiveRecord::Migration[6.0]
  def change
    add_column :structures, :parent_object_id, :integer
    add_column :structures, :child_object_id, :integer
  end
end
