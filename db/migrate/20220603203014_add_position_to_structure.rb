# frozen_string_literal: true

class AddPositionToStructure < ActiveRecord::Migration[6.0]
  def change
    add_column :structures, :position, :integer
  end
end
