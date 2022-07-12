# frozen_string_literal: true

class StructureRange < Structure
  def child_structures_as_iiif
    children = []
    structures.order('position').each do |s|
      children << s.to_iiif
    end
    children
  end

  def to_iiif
    {
      id: IiifRangeBuilder.uuid_to_uri(resource_id),
      type: 'Range',
      label: { "en": [label] },
      items: child_structures_as_iiif,
      partOf: [{
        id: IiifRangeBuilder.parent_uri_from_id(parent_object_id),
        type: 'Manifest'
      }]
    }
  end
end
