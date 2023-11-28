require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "#valid" do
    it 'fails if the rating is missing' do
      # arrange
      review = Review.new

      # act
      result = review.valid?

      # assert
      expect(result).to be false
      expect(review.errors.include? :rating).to be true
    end

    it 'fails if the comment is missing' do
      # arrange
      review = Review.new

      # act
      result = review.valid?

      # assert
      expect(result).to be false
      expect(review.errors.include? :comment).to be true
    end
  end
end
