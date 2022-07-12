# frozen_string_literal: true

class AddTypeToStructure < ActiveRecord::Migration[6.0]
  def change
    add_column :structures, :type, :string
  end
end
