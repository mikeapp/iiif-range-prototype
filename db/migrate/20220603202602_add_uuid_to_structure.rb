# frozen_string_literal: true

class AddUuidToStructure < ActiveRecord::Migration[6.0]
  def change
    add_column :structures, :resource_id, :string
  end
end
