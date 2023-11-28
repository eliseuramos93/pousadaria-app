require 'rails_helper'

RSpec.describe Consumable, type: :model do
  describe "#valid?" do
    it 'fails if no description is given' do
      # arrange
      consumable = Consumable.new

      # act
      result = consumable.valid?

      # assert
      expect(result).to be false
      expect(consumable.errors.include? :description).to be true
    end

    it 'fails if no price is given' do
      # arrange
      consumable = Consumable.new

      # act
      result = consumable.valid?

      # assert
      expect(result).to be false
      expect(consumable.errors.include? :price).to be true
    end
  end
end
