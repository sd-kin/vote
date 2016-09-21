# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:rating) { Rating.create }
  let(:user) { FactoryGirl.create(:user) }

  context 'when change value' do
    context '#increase' do
      it 'increase rating by 1' do
        expect { rating.increase_by(user: user) }.to change { rating.value }.by(1)
      end

      it 'adds user to upvoters' do
        rating.increase_by(user: user)
        expect(rating.reload.upvoters).to include(user)
      end

      it 'not adds user to downvoters' do
        rating.increase_by(user: user)
        expect(rating.reload.downvoters).to_not include(user)
      end
    end

    context '#decrease' do
      it 'decrease rating by 1' do
        expect { rating.decrease_by(user: user) }.to change { rating.value }.by(-1)
      end

      it 'not add user to upvoters' do
        rating.decrease_by(user: user)
        expect(rating.reload.upvoters).to_not include(user)
      end

      it 'adds user to downvoters' do
        rating.decrease_by(user: user)
        expect(rating.reload.downvoters).to include(user)
      end
    end
  end
end
