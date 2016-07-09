require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  context 'GET#index' do
    let!(:user1){FactoryGirl.create(:user)}
    let!(:user2){FactoryGirl.create(:user)}
    let!(:user3){FactoryGirl.create(:user)}

    it 'should be success' do 
      expect(get :index).to be_succes
    end

    it 'should get all users' do
      get :index
      expect(assigns(:users)).to match_array([user1, user2, user3])
    end
  end

end
