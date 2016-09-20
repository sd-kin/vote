# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:rating) { Rating.create }

  context 'when change value' do
    context '#increase' do
      it 'increase rating by 1' do
        expect { rating.increase }.to change { rating.value }.by(1)
      end
    end

    context '#decrease' do
      it 'decrease rating by 1' do
        expect { rating.decrease }.to change { rating.value }.by(-1)
      end
    end
  end
end
