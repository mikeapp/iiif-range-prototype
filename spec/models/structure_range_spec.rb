# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StructureRange, type: :model do
  context 'range can serialize' do
    before(:each) do
      parent = ParentObject.create(label: 'My book')
      p1 = ChildObject.create(label: 'p1')
      p2 = ChildObject.create(label: 'p2')
      p3 = ChildObject.create(label: 'p3')
      p4 = ChildObject.create(label: 'p4')

      @toc = StructureRange.create(top_level: true, position: 0, label: 'Table of Contents', resource_id: SecureRandom.uuid)
      @toc.parent_object = parent
      @toc.save

      c1 = StructureRange.create(position: 0, label: 'Chapter 1', parent_object: parent, resource_id: SecureRandom.uuid)
      c2 = StructureRange.create(position: 1, label: 'Chapter 2', parent_object: parent, resource_id: SecureRandom.uuid)
      @toc.structures << c1
      @toc.structures << c2

      p1s = StructureCanvas.create(position: 0, child_object: p1, parent_object: parent)
      p2s = StructureCanvas.create(position: 1, child_object: p2, parent_object: parent)
      c1.structures << p1s
      c1.structures << p2s

      p3s = StructureCanvas.create(position: 0, child_object: p3, parent_object: parent)
      p4s = StructureCanvas.create(position: 1, child_object: p4, parent_object: parent)
      c2.structures << p3s
      c2.structures << p4s
    end

    it 'generates two child ranges' do
      expect(@toc.structures.length).to eq(2)
    end

    it 'each child has children' do
      @toc.structures.each do |child|
        expect(child.structures.length).to eq(2)
      end
    end

    it 'leaf nodes are StructureCanvases' do
      @toc.structures.each do |child|
        child.structures.each do |grandchild|
          expect(grandchild).to be_a(StructureCanvas)
        end
      end
    end

    it 'serializes' do
      json = JSON.dump(@toc.to_iiif)
      puts json
      expect(json).to be_a(String)
      expect(json).to match('Chapter 2')
    end
  end
end
