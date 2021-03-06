# frozen_string_literal: true

class IiifRangeBuilder
  PREFIX = 'https://collections.library.yale.edu/manifests'

  def parse_structures(manifest)
    raise 'Not a Manifest' unless manifest['type'] == 'Manifest'
    raise 'No structures property' unless manifest['structures'] && !manifest['structures'].empty?

    results = []
    manifest_uri = manifest['id']
    parent = parent_object_from_uri(manifest_uri)
    ActiveRecord::Base.transaction do
      structures = manifest['structures']
      structures.each_with_index do |structure, index|
        top_level_range = parse_range(parent, structure, index)
        top_level_range.top_level = true
        top_level_range.save
        results.push top_level_range
      end
    end
    results
  end

  def parse_range(parent, range, position)
    raise 'Not a Range' unless range['type'] == 'Range'

    uri = range['id']
    id = uuid_from_uri(uri)
    destroy_existing_structure(id)
    result = StructureRange.create!(
      resource_id: id,
      label: range['label']['en'][0],
      position: position,
      parent_object_id: parent.id
    )
    items = range['items']

    items.each_with_index do |item, index|
      if item['type'] == 'Range'
        result.structures << parse_range(parent, item, index)
      elsif item['type'] == 'Canvas'
        result.structures << parse_canvas(parent, item, index)
      else
        raise 'Unexpected type for item in Range'
      end
    end
    result.save
    result
  end

  def parse_canvas(parent, item, position)
    child_id = child_id_from_uri(item['id'], parent.id)
    child = ChildObject.find(child_id)
    StructureCanvas.create!(
      label: child.label,
      position: position,
      parent_object_id: parent.id,
      child_object_id: child.id
    )
  end

  def uuid_from_uri(uri)
    uri.sub("#{PREFIX}/range/", '')
  end

  def parent_object_from_uri(uri)
    parent_id = parent_id_from_uri(uri)
    ParentObject.find(parent_id)
  end

  def parent_id_from_uri(uri)
    uri.sub("#{PREFIX}/oid/", '')
  end

  def self.parent_uri_from_id(id)
    "#{PREFIX}/#{id}"
  end

  def self.uuid_to_uri(uuid)
    "#{PREFIX}/range/#{uuid}"
  end

  def child_id_from_uri(uri, parent_id)
    uri.sub("#{PREFIX}/oid/#{parent_id}/canvas/", '')
  end

  def self.child_id_to_uri(child_id, parent_id)
    "#{PREFIX}/oid/#{parent_id}/canvas/#{child_id}"
  end

  def destroy_existing_structure(resource_id)
    Structure.where(resource_id: resource_id).destroy_all
  end
end
