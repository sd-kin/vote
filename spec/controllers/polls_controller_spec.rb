# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PollsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let!(:poll) { FactoryGirl.create(:valid_poll) }
  let!(:users_poll) { FactoryGirl.create(:valid_poll, user_id: user.id) }

  context 'index actions' do
    describe 'GET #index' do
      subject { get :index }

      it { is_expected.to be_success }

      it { is_expected.to render_template(:index) }

      it 'render all polls' do
        subject

        expect(assigns(:polls)).to eq(Poll.all)
      end
    end

    describe 'GET #ready' do
      subject { get :ready }

      it { is_expected.to be_success }

      it { is_expected.to render_template(:ready) }

      it 'render ready polls' do
        subject

        expect(assigns(:polls)).to match_array(Poll.ready)
      end

      it 'not render all polls' do
        subject

        expect(assigns(:polls)).not_to match_array(Poll.all)
      end
    end
  end

  describe 'GET #show' do
    subject { get :show, id: poll.id }
    context 'when poll exists' do
      it { is_expected.to be_success }

      it { is_expected.to render_template(:show) }

      it 'get poll' do
        subject

        expect(assigns(:poll)).to eq(poll)
      end

      it 'have correct voted status' do
        subject

        expect(assigns(:already_voted)).to be false
      end

      it 'mark voted poll' do
        poll.ready!
        preferences = poll.options.ids.map { |id| 'option_' + id.to_s }.reverse

        xhr :post, :choose, id: poll.id, choices_array: preferences
        xhr :get, :show, id: poll.id

        expect(assigns(:already_voted)).to be true
      end
    end

    context "when poll doesn't exist" do
      it 'have 404 responce statuse' do
        expect { get :show, id: 10 }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET #new' do
    subject { get :new }

    it { is_expected.to be_success }

    it { is_expected.to render_template(:new) }

    it 'build a new opject' do
      subject
      expect(assigns(:poll)).to be_a_new(Poll)
    end
  end

  describe 'POST #create' do
    subject { xhr :post, :create, poll: poll_params }

    context 'when valid attributes' do
      let(:poll_params) { FactoryGirl.attributes_for(:valid_poll) }

      context 'and user logged in' do
        before(:each) { session[:user_id] = user.id }

        it { is_expected.to be_success }

        it 'increase count of polls' do
          expect { subject }.to change { Poll.count }.by(1)
        end

        it 'not change count of users' do
          expect { subject }.to_not change { User.count }
        end
      end

      context 'and user not logged in' do
        it { is_expected.to be_success }

        it 'increase count of polls' do
          expect { subject }.to change { Poll.count }.by(1)
        end

        it 'increase count of users' do
          expect { subject }.to change { User.count }.by(1)
        end
      end
    end

    context 'when not valid attributes' do
      let(:poll_params) { FactoryGirl.attributes_for(:poll, :with_empty_title) }

      it { is_expected.to be_success }

      it { is_expected.to render_template(:create) }

      it 'have error' do
        subject
        expect(assigns(:poll).errors[:title]).to eq(["can't be blank"])
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, id: users_poll.id }

    context 'when user own poll' do
      before(:each) { session[:user_id] = user.id }

      it { is_expected.to have_http_status(302) }

      it 'not decrease count of polls' do
        expect { subject }.to_not change { Poll.count }
      end

      it 'change poll status to deleted' do
        subject
        expect(users_poll.reload).to be_deleted
      end
    end

    context 'when user dont own poll' do
      before(:each) { session[:user_id] = user.id + 1 }

      it { is_expected.to have_http_status(302) }

      it 'not decrease count of polls' do
        expect { subject }.to_not change { Poll.count }
      end

      it 'have access denied error' do
        subject
        expect(flash[:error]).to eq('only owner can do that')
      end
    end
  end

  describe 'PUT #update' do
    subject { xhr :put, :update, id: users_poll.id, poll: poll_params }

    context 'when user own poll' do
      before(:each) { session[:user_id] = user.id }

      context 'and atributes valid' do
        let(:poll_params) { FactoryGirl.attributes_for(:updated_poll) }

        it { is_expected.to be_success }

        it { is_expected.to render_template(:update) }

        it 'change poll attributes' do
          subject
          expect(users_poll.reload.title).to eq(poll_params[:title])
        end

        it 'not increase count of polls' do
          expect { subject }.to change { Poll.count }.by(0)
        end

        it 'change status back to draft' do
          users_poll.ready!

          subject

          expect(users_poll.reload).to be_draft
        end
      end

      context 'and attributes not valid' do
        let(:poll_params) { FactoryGirl.attributes_for(:poll, title: nil) }

        it { is_expected.to be_success }

        it { is_expected.to render_template :update }

        it 'have title validation message' do
          subject
          expect(assigns(:poll).errors[:title]).to eq(["can't be blank"])
        end

        it 'not change poll attributes' do
          subject
          expect(users_poll.reload.title).not_to eq(poll_params[:title])
        end
      end

      context 'when user dont own poll' do
        let(:poll_params) { FactoryGirl.attributes_for(:updated_poll) }

        before(:each) { session[:user_id] = user.id + 1 }

        it 'not change poll attributes' do
          subject
          expect(users_poll.reload.title).not_to eq(poll_params[:title])
        end

        it { is_expected.to redirect_to root_path }

        it 'have acces denied message' do
          subject
          expect(flash[:error]).to eq('only owner can do that')
        end
      end
    end
  end

  describe 'GET #edit' do
    subject { get :edit, id: users_poll.id }

    context 'when user own poll' do
      before(:each) { session[:user_id] = user.id }

      it { is_expected.to render_template(:edit) }

      it { is_expected.to be_success }
    end

    context 'when user doesnt own poll' do
      before(:each) { session[:user_id] = user.id + 1 }

      it { is_expected.to redirect_to root_path }

      it 'have error' do
        subject
        expect(flash[:error]).to_not be_empty
      end
    end
  end

  describe 'POST #choose' do
    let(:poll) { FactoryGirl.create :valid_poll, status: 'ready' }
    subject { xhr :post, :choose, id: poll.id, choices_array: preferences }
    let(:preferences) { poll.options.ids.map { |id| 'option_' + id.to_s }.reverse }

    it { is_expected.to be_success }

    it 'save preferences as weights' do
      subject

      expect(assigns(:poll).vote_results.first).to eq([0, 1, 2])
    end

    it 'save vote results if vote cast in first time' do
      expect { subject }.to change { poll.reload.vote_results.count }.by(1)
    end

    it 'save vote results only once' do
      expect { 2.times { subject } }.to change { poll.reload.vote_results.count }.by(1)
    end

    it 'save correct current state' do
      subject

      expect(assigns(:poll).options_in_rank).to eq(Hash[[0, 1, 2].zip(poll.options.ids.map { |x| [x] })])
    end
  end

  describe 'GET #result' do
    subject { get :result, id: poll.id }

    it { is_expected.to be_success }
  end

  describe 'POST #make_ready' do
    subject { xhr :post, :make_ready, id: users_poll.id }

    context 'when user owns poll' do
      before(:each) { session[:user_id] = user.id }

      it 'change status to ready' do
        expect { subject }.to change { users_poll.reload.status }.from('draft').to('ready')
      end
    end

    context 'when user doesnt own poll' do
      before(:each) { session[:user_id] = user.id + 1 }

      it 'not change status from draft' do
        expect { subject }.not_to change { users_poll.reload.status }
      end

      it 'have an error' do
        subject
        expect(flash[:error]).to_not be_empty
      end
    end
  end

  describe 'POST #make_draft' do
    subject { xhr :post, :make_draft, id: users_poll.id }
    before(:each) { users_poll.ready! }

    context 'when user owns poll' do
      before(:each) { session[:user_id] = user.id }
      it 'change status to draft' do
        expect { subject }.to change { users_poll.reload.status }.from('ready').to('draft')
      end
    end

    context 'if user doesnt own poll' do
      before(:each) { session[:user_id] = user.id + 1 }

      it 'not change status from ready' do
        expect { subject }.not_to change { users_poll.reload.status }
      end

      it 'have an error' do
        subject
        expect(flash[:error]).to_not be_empty
      end
    end
  end
end
