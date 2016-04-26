require 'rails_helper'

RSpec.describe OptionsController, type: :controller do
  describe 'GET #index' do

  end

  describe 'GET #show' do
    context 'when option exist' do
      it 'request should be succes' do 
        poll = FactoryGirl.create(:valid_poll)
        option = poll.options.first
        expect(xhr :get, :show, poll_id: poll, id: option).to be_succes
      end

      it 'should get right poll' do 
        poll = FactoryGirl.create(:valid_poll)
        option = poll.options.first
        xhr :get, :show, poll_id: poll, id: option
        expect(assigns(:option)).to eq(option)
      end
    end

    context 'when option does not exist' do 

    end
  end

  describe 'GET #new' do 

  end

  describe 'GET #edit' do 

  end

  describe 'PUT #create' do 

  end

  describe 'PUT #update' do

  end

  describe 'DESTROY #delete' do 

  end
end
