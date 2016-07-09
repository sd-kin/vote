require 'rails_helper'

RSpec.describe User, type: :model do
  context 'when create user' do
    it 'should can create user with username and email' do
      expect{FactoryGirl.create(:user)}.to change{User.count}.by(1)
    end
  end
end
