# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Comments::Update do
  let(:service_call)   { Services::Comments::Update.call(comment, params) }
  let(:params)         { ActionController::Parameters.new(comment: comment_params) }
  let(:comment_params) { FactoryGirl.attributes_for :comment }
  let(:comment)        { FactoryGirl.create :comment }

  it 'changes comment body' do
    expect { service_call }.to change { comment.body }.to(comment_params[:body])
  end

  context 'images' do
    context 'add' do
      let(:comment_params) { FactoryGirl.attributes_for :comment, images: [File.new('spec/fixtures/files/test_image.png')] }

      it 'increase images count' do
        expect { service_call }.to change { comment.images.count }.from(0).to(1)
      end
    end

    context 'remove' do
      let(:comment) { FactoryGirl.create :comment, :with_image }
      let(:params)  { ActionController::Parameters.new(comment: comment_params, ids_of_images_for_delete: [comment.images.first.id.to_s]) }

      it 'decrease images count' do
        expect { service_call }.to change { comment.images.count }.from(1).to(0)
      end
    end
  end
end
