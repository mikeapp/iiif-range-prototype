# frozen_string_literal: true

class StructureCanvas < Structure
  belongs_to :child_object

  def to_iiif
    {
      id: IiifRangeBuilder.child_id_to_uri(child_object.id, parent_object.id),
      type: 'Canvas'
    }
  end
end
