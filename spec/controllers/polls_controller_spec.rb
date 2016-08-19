# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PollsController, type: :controller do
  context 'index actions' do
    let!(:poll1) { FactoryGirl.create(:valid_poll) }
    let!(:poll2) { FactoryGirl.create(:valid_poll) }
    let!(:poll3) { FactoryGirl.create(:valid_poll, status: 'ready') }

    describe 'GET #index' do
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

    describe 'GET #ready' do
      it 'should succesful get ready page' do
        expect(get :ready).to be_succes
      end

      it 'should render ready template' do
        expect(get :ready).to render_template(:ready)
      end

      it 'should render ready polls' do
        get :ready
        expect(assigns(:polls)).to match_array(Poll.ready)
      end

      it 'should not render all polls' do
        get :ready
        expect(assigns(:polls)).not_to match_array(Poll.all)
      end
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

      it 'should not mark non-voted poll as voted' do
        xhr :get, :show, id: poll.id

        expect(assigns(:already_voted)).to be false
      end

      it 'shold check if poll been already voted' do
        preferences = poll.options.ids.map { |id| 'option_' + id.to_s }.reverse

        xhr :post, :choose, id: poll.id, choices_array: preferences
        xhr :get, :show, id: poll.id

        expect(assigns(:already_voted)).to be true
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

      context 'and user logged in' do
        subject { xhr :post, :create, poll: poll_params }
        before(:each) { session[:user_id] = FactoryGirl.create(:user).id }

        context 'and poll saving' do
          it { is_expected.to be_succes }

          it 'should increase count of polls' do
            expect { xhr :post, :create, poll: poll_params }.to change { Poll.count }.by(1)
          end
        end
      end

      context 'and user not logged in' do
        it 'should be success' do
          expect(xhr :post, :create, poll: poll_params).to be_succes
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
      expect(get :edit, id: poll.id).to be_success
    end
    it 'should render template edit' do
      expect(get :edit, id: poll.id).to render_template(:edit)
    end
  end

  describe 'POST #choose' do
    let(:poll) { FactoryGirl.create(:valid_poll) }
    let(:preferences) { poll.options.ids.map { |id| 'option_' + id.to_s }.reverse }

    it 'should save preferences as weights' do
      xhr :post, :choose, id: poll.id, choices_array: preferences

      expect(assigns(:poll).vote_results.first).to eq([0, 1, 2])
    end

    it 'should be succes' do
      expect(xhr :post, :choose, id: poll.id, choices_array: preferences).to be_succes
    end

    it 'should save vote results if vote cast in first time' do
      xhr :post, :choose, id: poll.id, choices_array: preferences

      expect { poll.reload }.to change { poll.vote_results.count }.by(1)
    end

    it 'should save vote results only once' do
      expect do
        2.times { xhr :post, :choose, id: poll.id, choices_array: preferences }
      end.to change { poll.reload.vote_results.count }.by(1)
    end

    it 'should save correct current state' do
      xhr :post, :choose, id: poll.id, choices_array: preferences

      expect(assigns(:poll).options_in_rank).to eq(Hash[[0, 1, 2].zip(poll.options.ids.map { |x| [x] })])
    end
  end

  describe 'GET #result' do
    let(:poll) { FactoryGirl.create(:valid_poll) }

    it 'should success get result page' do
      expect(get :result, id: poll.id).to be_succes
    end
  end
end
