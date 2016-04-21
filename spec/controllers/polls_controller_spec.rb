require 'rails_helper'

RSpec.describe PollsController, type: :controller do
  describe 'GET #index' do
    let(:poll) { FactoryGirl.create(:valid_poll) }

    it 'should succesful get index' do
      expect(get :index).to be_succes
    end

    it 'should render index template' do
      expect(get :index).to render_template(:index)
    end

    it 'should render all polls' do
      get :index
      expect(assigns(:polls)).to eq([poll])
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
          expect(post :create, poll: poll_params).to be_succes
        end
        it 'should increase count of polls and do it' do
          expect { post :create, poll: { title: 'test', options_attributes: { '0' => { title: 'option title', description: 'description' } } } }.to change { Poll.count }.by(1)
        end
      end

      context 'and build options' do
        let(:poll_params) { { 'title' => 'adding option', 'options_attributes' => { '0' => { 'title' => 't1', 'description' => 'd1' }, '1' => { 'title' => 't2', 'description' => 'd2' } } } }
        let(:poll_params2) { { 'title' => 'adding option', 'options_attributes' => { '0' => { 'title' => 't1', 'description' => 'd1' }, '1' => { 'title' => 't2', 'description' => 'd2' }, '2' => { 'title' => 't3', 'description' => 'd3' } } } }
        it 'should be success' do
          expect(post :create, poll: poll_params, add_option: 'add_option').to be_succes
        end
        it 'should render template new' do
          expect(post :create, poll: poll_params, add_option: 'add_option').to render_template(:new)
        end
        it 'should increase count of options' do
          post :create, poll: poll_params, add_option: 'add_option'
          x = assigns(:poll).options.size
          post :create, poll: poll_params2, add_option: 'add_option'
          y = assigns(:poll).options.size

          expect(y - x).to eq(1)
        end
      end
    end

    context 'when not valid attributes' do
      let(:poll_params) { FactoryGirl.attributes_for(:poll).merge('_destroy' => 0) } # parameter destroy necessary. No title, no option but destroy.

      it 'should be success' do
        expect(post :create, poll: poll_params).to be_succes
      end
      it 'should render template new' do
        expect(post :create, poll: poll_params).to render_template(:new)
      end
      it 'should throwing error without a title' do
        post :create, poll: FactoryGirl.attributes_for(:poll, :with_options)
        expect(assigns(:poll).errors[:title]).to eq(["can't be blank"])
      end
      it 'should throwing error without an options' do
        post :create, poll: FactoryGirl.attributes_for(:poll, :with_options)
        expect(assigns(:poll).errors[:options]).to eq(["can't be blank"])
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
      context 'and poll saving' do
        let(:poll) { FactoryGirl.create(:valid_poll) }
        let(:updated_poll_params) { FactoryGirl.attributes_for(:updated_poll) }

        it 'should be succes' do
          expect(put :update, id: poll.id, poll: updated_poll_params).to have_http_status(302)
        end
        it 'should redirrect to polls path' do
          expect(put :update, id: poll.id, poll: updated_poll_params).to redirect_to(poll_path(poll))
        end
        it 'should change poll attributes' do
          put :update, id: poll.id, poll: updated_poll_params
          poll.reload
          expect(poll.title).to eq(updated_poll_params[:title])
        end
        it 'should not increase count of polls' do
          poll = FactoryGirl.create(:valid_poll)
          expect { put :update, id: poll.id, poll: updated_poll_params }.to change { Poll.count }.by(0)
        end
      end

      context 'and build options' do
        let(:poll) { FactoryGirl.create(:valid_poll) }
        let(:updated_poll_params) { { 'title' => 'adding option', 'options_attributes' => { '0' => { 'title' => 'title', 'description' => 'description' } } } }
        it 'should be success' do
          expect(put :update, id: poll.id, poll: updated_poll_params).to have_http_status(302)
        end
        it 'should render template new' do
          expect(put :update, id: poll.id, poll: updated_poll_params, add_option: 'Add option').to render_template(:edit)
        end
        it 'should increase count of options' do
          options_count_before = poll.options.size
          put :update, id: poll.id, poll: updated_poll_params
          poll.reload
          options_count_after = poll.options.size
          expect(options_count_after - options_count_before).to eq(1)
        end
      end
    end

    context 'when not valid attributes' do
      let(:not_valid_poll_params) { FactoryGirl.attributes_for(:poll, title: nil).merge('_destroy' => 0) }
      let(:poll) { FactoryGirl.create(:valid_poll) }
      it 'should be success' do
        expect(put :update, id: poll.id, poll: not_valid_poll_params).to be_success
      end
      it 'should render template edit' do
        expect(put :update, id: poll.id, poll: not_valid_poll_params).to render_template :edit
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
