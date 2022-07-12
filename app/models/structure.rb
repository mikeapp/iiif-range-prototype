# frozen_string_literal: true

class Structure < ApplicationRecord
  has_many :structures, dependent: :destroy
  belongs_to :parent_object
end
