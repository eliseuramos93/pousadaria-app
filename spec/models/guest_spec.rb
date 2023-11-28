require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe '#valid?' do
    it 'fails if full_name is blank' do
      # arrange
      guest = Guest.new

      # act
      result = guest.valid?

      # assert
      expect(result).to be false
      expect(guest.errors.include? :full_name).to be true
    end

    it 'fails if document is blank' do
      # arrange
      guest = Guest.new

      # act
      result = guest.valid?

      # assert
      expect(result).to be false
      expect(guest.errors.include? :document).to be true
    end
  end  
end
