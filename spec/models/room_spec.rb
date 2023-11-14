require 'rails_helper'

RSpec.describe Room, type: :model do
  describe '#valid?' do
    it 'must have all of the mandatory fields to be valid' do
      # arrange
      room = Room.new

      # act
      room.valid?

      # assert
      expect(room.errors.include? :name).to be true
      expect(room.errors.include? :description).to be true
      expect(room.errors.include? :area).to be true
      expect(room.errors.include? :max_capacity).to be true
      expect(room.errors.include? :rent_price).to be true
    end
  end
end
