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

      it 'increase rating by 2 if downvoted before' do
        rating.decrease_by(user: user)
        expect { rating.increase_by(user: user) }.to change { rating.value }.by(2)
      end

      it 'increase rating only once' do
        rating.increase_by(user: user)
        expect { rating.increase_by(user: user) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'adds user to upvoters' do
        rating.increase_by(user: user)
        expect(rating.reload.upvoters).to include(user)
      end

      it 'not adds user to downvoters' do
        rating.increase_by(user: user)
        expect(rating.reload.downvoters).to_not include(user)
      end

      it 'change rated status' do
        expect(rating.increased_by?(user)).to be_falsey
        rating.increase_by(user: user)
        expect(rating.reload.increased_by?(user)).to be_truthy
      end

      it 'removes user from decreased' do
        rating.decrease_by(user: user)
        expect(rating.decreased_by?(user)).to be_truthy
        rating.increase_by(user: user)
        expect(rating.decreased_by?(user)).to be_falsey
      end

      it 'not change status if cant delete from downvoters' do
        allow(rating.downvoters).to receive(:delete).and_return(false)
        rating.decrease_by(user: user)
        expect { rating.increase_by(user: user) }.to_not change { rating.value }
        expect { rating.increase_by(user: user) }.to change { rating.errors.count }
      end
    end

    context '#decrease' do
      it 'decrease rating by 1' do
        expect { rating.decrease_by(user: user) }.to change { rating.value }.by(-1)
      end

      it 'decrease rating by 2 if upvoted before' do
        rating.increase_by(user: user)
        expect { rating.decrease_by(user: user) }.to change { rating.value }.by(-2)
      end

      it 'decrease rating only once' do
        rating.decrease_by(user: user)
        expect { rating.decrease_by(user: user) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'not add user to upvoters' do
        rating.decrease_by(user: user)
        expect(rating.reload.upvoters).to_not include(user)
      end

      it 'adds user to downvoters' do
        rating.decrease_by(user: user)
        expect(rating.reload.downvoters).to include(user)
      end

      it 'change rated status' do
        expect(rating.decreased_by?(user)).to be_falsey
        rating.decrease_by(user: user)
        expect(rating.reload.decreased_by?(user)).to be_truthy
      end

      it 'removes user from increased' do
        rating.increase_by(user: user)
        expect(rating.increased_by?(user)).to be_truthy
        rating.decrease_by(user: user)
        expect(rating.increased_by?(user)).to be_falsey
      end

      it 'not change status if cant delete from upnvoters' do
        allow(rating.upvoters).to receive(:delete).and_return(false)
        rating.increase_by(user: user)
        expect { rating.decrease_by(user: user) }.to_not change { rating.value }
        expect { rating.decrease_by(user: user) }.to change { rating.errors.count }
      end
    end
  end
end
