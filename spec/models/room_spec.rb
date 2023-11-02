require 'rails_helper'

RSpec.describe Room, type: :model do
  describe '#valid?' do
    it 'must have a name to be valid' do
      # arrange
      room = Room.new

      # act
      room.valid?

      # assert
      expect(room.errors.include? :name).to be true
    end

    it 'must have a description to be valid' do
      # arrange
      room = Room.new

      # act
      room.valid?

      # assert
      expect(room.errors.include? :description).to be true
    end

    it 'must have an area to be valid' do
      # arrange
      room = Room.new

      # act
      room.valid?

      # assert
      expect(room.errors.include? :area).to be true
    end

    it 'must have a maximum capacity to be valid' do
      # arrange
      room = Room.new

      # act
      room.valid?

      # assert
      expect(room.errors.include? :max_capacity).to be true
    end

    it 'must have a rent price to be valid' do
      # arrange
      room = Room.new

      # act
      room.valid?

      # assert
      expect(room.errors.include? :rent_price).to be true
    end
  end
end
