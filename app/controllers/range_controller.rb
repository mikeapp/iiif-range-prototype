# frozen_string_literal: true

class RangeController < ApplicationController
  def index
    text 'Range controller'
  end

  def show
    render json: StructureRange.where(resource_id: params[:id]).first.to_iiif
  end

  def create
    rb = IiifRangeBuilder.new
    parent = ParentObject.find(params[:parent_object_id])
    range = rb.parse_range(parent, JSON.parse(request.raw_post), nil)
    range.parent_object = parent
    redirect_to "/range/#{range.resource_id}"
  end

  def update
    rb = IiifRangeBuilder.new
    parent = ParentObject.find(params[:parent_object_id])
    json = JSON.parse(request.raw_post)
    id = rb.uuid_from_uri(json['id'])
    exists = StructureRange.exists?(resource_id: id)
    range = rb.parse_range(parent, json, nil)
    status_code = exists ? :ok : :created
    render json: range.to_iiif, status: status_code
  end

end
