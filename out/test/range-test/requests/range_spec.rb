# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ranges', type: :request do
  describe 'POST /range' do
    it 'parses a Manifest' do
      rb = IiifRangeBuilder.new
      parent = ParentObject.create
      child = ChildObject.create
      json = File.read(Rails.root.join('spec/fixtures/range1.json'))
      json = format(json, parent_id: parent.id, child_id: child.id)
      range = JSON.parse(json)
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post "/parent_object/#{parent.id}/range", params: JSON.pretty_generate(range), headers: headers
      id = rb.uuid_from_uri(range['id'])
      expect(response).to redirect_to( "/range/#{id}" )
      expect(response).to have_http_status(:found)
    end
  end

  describe 'PUT /range' do
    it 'updates  a Manifest' do
      rb = IiifRangeBuilder.new
      parent = ParentObject.create
      child = ChildObject.create
      json = File.read(Rails.root.join('spec/fixtures/range1.json'))
      json = format(json, parent_id: parent.id, child_id: child.id)
      manifest = JSON.parse(json)
      range = rb.parse_range(parent, manifest, 1)
      headers = { 'CONTENT_TYPE' => 'application/json' }
      put "/parent_object/#{parent.id}/range/#{range.resource_id}", params: JSON.pretty_generate(manifest), headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'updates  a Manifest' do
      rb = IiifRangeBuilder.new
      parent = ParentObject.create
      child = ChildObject.create
      json = File.read(Rails.root.join('spec/fixtures/range1.json'))
      json = format(json, parent_id: parent.id, child_id: child.id)
      manifest = JSON.parse(json)
      id = rb.uuid_from_uri(manifest['id'])
      headers = { 'CONTENT_TYPE' => 'application/json' }
      put "/parent_object/#{parent.id}/range/#{id}", params: JSON.pretty_generate(manifest), headers: headers
      expect(response).to have_http_status(:created)
    end
  end
end
