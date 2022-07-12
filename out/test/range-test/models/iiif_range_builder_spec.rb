# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IiifRangeBuilder, type: :model do
  context 'Deserializiation' do
    before(:each) do
      @parent = ParentObject.create
      @child = ChildObject.create
      json = File.read(Rails.root.join('spec/fixtures/v3_spec_manifest.json'))
      json = format(json, parent_id: @parent.id, child_id: @child.id)
      @manifest = JSON.parse(json)
      json2 = File.read(Rails.root.join('spec/fixtures/v3_spec_manifest_changed_labels.json'))
      json2 = format(json2, parent_id: @parent.id, child_id: @child.id)
      @manifest2 = JSON.parse(json2)
      @rb = IiifRangeBuilder.new
    end


    it 'parses the structure' do
      structures = @rb.parse_structures(@manifest)
      expect(structures).to be_a(Array)
      expect(structures.length).to be(1)
      top_level_range = structures.first
      expect(top_level_range.label).to eq('Table of Contents')
      expect(top_level_range.top_level).to be(true)
      expect(top_level_range.parent_object_id).to eq(@parent.id)
      expect(top_level_range.position).to eq(0)
    end

    it 'parses the child range' do
      structures = @rb.parse_structures(@manifest)
      range = structures[0]
      child = range.structures.first
      expect(child.label).to eq('Introduction')
      expect(child.parent_object_id).to eq(@parent.id)
      expect(child.position).to eq(0)
    end

    it 'associates with a parent' do
      @rb.parse_structures(@manifest)
      parent = @rb.parent_object_from_uri(@manifest['id'])
      found = StructureRange.where(parent_object_id: parent.id, top_level: true)
      expect(found.length).to eq(1)
    end

    it 'deletes and recreates the structures when IDs match' do
      structures = @rb.parse_structures(@manifest)
      range = structures[0]
      child = range.structures.first
      expect(child.label).to eq('Introduction')
      expect(child.parent_object_id).to eq(@parent.id)
      expect(child.position).to eq(0)
      expect(Structure.where(parent_object_id: @parent.id).length).to eq(3)
      structures2 = @rb.parse_structures(@manifest2)
      range2 = structures2[0]
      child2 = range2.structures.first
      canvas = child2.structures.first
      expect(child2.label).to eq('New Introduction')
      expect(Structure.where(parent_object_id: @parent.id).length).to eq(3)
      expect(canvas).to be_a(StructureCanvas)
    end

    it 'maintains the current data in case of error' do
      @rb.parse_structures(@manifest)
      expect(Structure.where(parent_object_id: @parent.id).length).to eq(3)
      manifest2 = JSON.parse(File.read(Rails.root.join('spec/fixtures/v3_spec_manifest_bad_child_id.json')))
      begin
        @rb.parse_structures(manifest2)
      rescue ActiveRecord::RecordNotFound
        # ActiveRecord::RecordNotFound is expected
      end
      expect(Structure.where(parent_object_id: @parent.id).length).to eq(3)
    end
  end

  context 'Serialization' do
    it 'serializes to JSON' do
      rb = IiifRangeBuilder.new
      parent = ParentObject.create!
      child = ChildObject.create!
      json = File.read(Rails.root.join('spec/fixtures/v3_spec_manifest.json'))
      json = format(json, parent_id: parent.id, child_id: child.id)
      manifest = JSON.parse(json)
      structures = rb.parse_structures(manifest)
      json = JSON.pretty_generate(structures.first.to_iiif)
      expect(json).to match("\"id\": \"https://collections.library.yale.edu/manifests/oid/#{parent.id}/canvas/#{child.id}\"")
    end
  end
end
