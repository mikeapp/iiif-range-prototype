# frozen_string_literal: true

desc 'Create a sample structure'
task create_structure_task: [:environment] do
  parent = ParentObject.create(label: 'My book')
  p1 = ChildObject.create(label: 'p1')
  p2 = ChildObject.create(label: 'p2')
  p3 = ChildObject.create(label: 'p3')
  p4 = ChildObject.create(label: 'p4')

  toc = StructureRange.create(top_level: true, position: 0, label: 'Table of Contents')
  toc.parent_object = parent
  toc.save

  c1 = StructureRange.create(position: 0, label: 'Chapter 1', parent_object: parent)
  c2 = StructureRange.create(position: 1, label: 'Chapter 2', parent_object: parent)
  toc.structures << c1
  toc.structures << c2

  p1s = StructureCanvas.create(position: 0, child_object: p1, parent_object: parent)
  p2s = StructureCanvas.create(position: 1, child_object: p2, parent_object: parent)
  c1.structures << p1s
  c1.structures << p2s

  p3s = StructureCanvas.create(position: 0, child_object: p3, parent_object: parent)
  p4s = StructureCanvas.create(position: 1, child_object: p4, parent_object: parent)
  c2.structures << p3s
  c2.structures << p4s

  puts toc.structures
end
