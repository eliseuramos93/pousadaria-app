require 'rails_helper'

describe 'Host deletes a picture from the room album' do
  it 'sucessfully' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'}, status: 'active')
    room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                        max_capacity: 2, rent_price: 50, status: :active)
    album = room.create_album!
    
    album.photos.attach(io: File.open(Rails.root.join('spec', 'resources', 'images', 'inn1.jpg')), 
                 filename: 'inn1.jpg')
    
    # act
    login_as user
    visit room_path(room)
    click_on 'Deletar foto'
    
    # assert
    expect(current_path).to eq room_path(room)
    expect(page).to have_content 'Sua foto foi deletada com sucesso'
    expect(page).not_to have_css('img[src*="inn1.jpg"]')
  end

  it 'only if authenticated as the inn owner' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    guest = User.create!(email: 'billy@gmail.com', password: 'testpass',
                                role: :regular)

    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'}, status: 'active')

    room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :active)

    album = room.create_album!
    
    album.photos.attach(io: File.open(Rails.root.join('spec', 'resources', 'images', 'inn1.jpg')), 
                 filename: 'inn1.jpg')

    # act
    login_as guest
    visit room_path(room)

    # assert
    expect(page).to have_css('img[src*="inn1.jpg"]')
    expect(page).not_to have_button 'Deletar foto'
  end 
end