require 'rails_helper'

RSpec.describe Album, type: :model do
  describe '#valid?' do
    it 'fails if receives a file that is not jpg, jpeg or png' do
      # arrange
      album = Album.new
      album.photos.attach(io: File.open(Rails.root.join('spec', 'resources', 'pdfs', 'pdf1.pdf')), 
                 filename: 'pdf1.pdf')

      # act
      result = album.valid?

      # assert
      expect(result).to eq false
      expect(album.errors.include? :photos).to eq true
    end
  end
end
