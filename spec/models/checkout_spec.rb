require 'rails_helper'

RSpec.describe Checkout, type: :model do
  describe '#valid?' do
    it 'fails if a payment method is not provided' do
      # arrange
      checkout = Checkout.new

      # act
      checkout.valid?

      # assert
      expect(checkout.errors.include? :payment_method)
      expect(checkout.errors.full_messages).to include 'Forma de pagamento não pode ficar em branco'
    end
  end
end
