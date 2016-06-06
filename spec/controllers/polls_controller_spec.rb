# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PollsController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      FactoryGirl.create(:valid_poll)
      FactoryGirl.create(:valid_poll)
      FactoryGirl.create(:valid_poll, :with_ready_status)
    end

    it 'should succesful get index' do
      expect(get :index).to be_succes
    end

    it 'should render index template' do
      expect(get :index).to render_template(:index)
    end

    it 'should render all polls' do
      get :index
      expect(assigns(:polls)).to eq(Poll.all)
    end
  end

  describe 'GET #ready_index' do
    before(:each) do
      FactoryGirl.create(:valid_poll)
      FactoryGirl.create(:valid_poll)
      FactoryGirl.create(:valid_poll, :with_ready_status)
    end

    it 'should succesful get ready index' do
      expect(get :ready_index).to be_succes
    end

    it 'should render ready index template' do
      expect(get :ready_index).to render_template(:ready_index)
    end

    it 'should render ready polls' do
      get :ready_index
      expect(assigns(:polls)).to eq(Poll.ready)
    end

    it 'should not render all polls' do
      get :ready_index
      expect(assigns(:polls)).not_to eq(Poll.all)
    end
  end

  describe 'GET #show' do
    let(:poll) { FactoryGirl.create(:valid_poll) }
    context 'when poll exists' do
      it 'should have succes responce' do
        expect(get :show, id: poll.id).to be_succes
      end

      it 'shold render show view' do
        expect(get :show, id: poll.id).to render_template(:show)
      end

      it 'shold render poll' do
        get :show, id: poll.id
        expect(assigns(:poll)).to eq(poll)
      end
    end

    context "when poll doesn't exist" do
      it 'should have 404 responce statuse' do
        id = 10
        expect { get :show, id: id }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET #new' do
    it 'shold be succes' do
      expect(get :new).to be_succes
    end
    it 'should render template new' do
      expect(get :new).to render_template(:new)
    end
    it 'should build a new opject' do
      get :new
      expect(assigns(:poll)).to be_a_new(Poll)
    end
  end

  describe 'POST #create' do
    context 'when valid attributes' do
      let(:poll_params) { FactoryGirl.attributes_for(:valid_poll) }
      context 'and poll saving' do
        it 'should be succes' do
          expect(xhr :post, :create, poll: poll_params).to be_succes
        end
        it 'should increase count of polls' do
          expect { xhr :post, :create, poll: poll_params }.to change { Poll.count }.by(1)
        end
      end
    end

    context 'when not valid attributes' do
      let(:poll_params) { FactoryGirl.attributes_for(:poll, :with_empty_title) }
      it 'should be success' do
        expect(xhr :post, :create, poll: poll_params).to be_succes
      end
      it 'should processing by template create' do
        expect(xhr :post, :create, poll: poll_params).to render_template(:create)
      end
      it 'should throwing error without a title' do
        xhr :post, :create, poll: FactoryGirl.attributes_for(:poll, :with_empty_title)
        expect(assigns(:poll).errors[:title]).to eq(["can't be blank"])
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:poll) { FactoryGirl.create(:valid_poll) }
    it 'should be success' do
      delete :destroy, id: poll.id

      expect(response).to have_http_status(302)
    end
    it 'should decrease count of polls' do
      poll = FactoryGirl.create(:valid_poll)
      expect { delete :destroy, id: poll.id }.to change { Poll.count }.by(-1)
    end
  end

  describe 'PUT #update' do
    context 'when valid attributes' do
      let(:poll) { FactoryGirl.create(:valid_poll) }
      let(:updated_poll_params) { FactoryGirl.attributes_for(:updated_poll) }

      it 'should be succes' do
        expect(xhr :put, :update, id: poll.id, poll: updated_poll_params).to have_http_status(200)
      end
      it 'should brocessed by update js template' do
        expect(xhr :put, :update, id: poll.id, poll: updated_poll_params).to render_template(:update)
      end
      it 'should change poll attributes' do
        xhr :put, :update, id: poll.id, poll: updated_poll_params
        poll.reload
        expect(poll.title).to eq(updated_poll_params[:title])
      end
      it 'should not increase count of polls' do
        poll = FactoryGirl.create(:valid_poll)
        expect { xhr :put, :update, id: poll.id, poll: updated_poll_params }.to change { Poll.count }.by(0)
      end
    end

    context 'when not valid attributes' do
      let(:not_valid_poll_params) { FactoryGirl.attributes_for(:poll, title: nil) }
      let(:poll) { FactoryGirl.create(:valid_poll) }
      it 'should be success' do
        expect(xhr :put, :update, id: poll.id, poll: not_valid_poll_params).to be_success
      end
      it 'should processing by update js template' do
        expect(xhr :put, :update, id: poll.id, poll: not_valid_poll_params).to render_template :update
      end
      it 'should have title validation message' do
        xhr :put, :update, id: poll.id, poll: not_valid_poll_params
        expect(assigns(:poll).errors[:title]).to eq(["can't be blank"])
      end
    end
  end

  describe 'GET #edit' do
    let(:poll) { FactoryGirl.create(:valid_poll) }

    it 'should be success' do
      expect(get :edit, id: poll.id).to be_succes
    end
    it 'should render template edit' do
      expect(get :edit, id: poll.id).to render_template(:edit)
    end
  end
end
