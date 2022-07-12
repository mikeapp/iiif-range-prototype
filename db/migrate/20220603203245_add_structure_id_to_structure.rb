# frozen_string_literal: true

class AddStructureIdToStructure < ActiveRecord::Migration[6.0]
  def change
    add_column :structures, :structure_id, :integer
  end
end
