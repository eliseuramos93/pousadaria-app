require 'rails_helper'

describe 'User requests to update a room' do
  it 'but must be authenticated' do
    # arrange
    foobar_inn_id = 128390128   # mashed the numpad for a random number
    foobar_room_id = 19283091823

    # act
    patch inn_room_path(foobar_inn_id, foobar_room_id, room: {foo_attr: 'lorem ipsum'})

    # assert
    expect(response).to redirect_to new_user_session_path
  end

  it 'but is not authorized due to being a regular user' do
    # arrange
      # create user as regular to force an impossible scenario through rails,
      # but possible through direct input in database.
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :regular)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
              registration_number: '58277983000198', 
              phone_number: '(11) 976834383', checkin_time: '18:00',
              checkout_time: '11:00', address_attributes: {
                street_name: 'Av. da Pousada', number: '10', 
                neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                state: 'SP', zip_code: '05616-090'})
    room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                max_capacity: 2, rent_price: 50, status: :active)

    # act
    login_as user
    patch inn_room_path(inn.id, room.id, room:  {name: 'lorem ipsum'})

    # assert
      # prove that rails prevents a regular user to edit an inn, even if the 
      # user owns the inn in a "system breach"
    expect(response).to redirect_to root_path
  end

  it "but is not authorized due to not being the inn's host" do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    another_user = User.create!(email: 'billy@gmail.com', password: 'password',
                        role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
              registration_number: '58277983000198', 
              phone_number: '(11) 976834383', checkin_time: '18:00',
              checkout_time: '11:00', address_attributes: {
                street_name: 'Av. da Pousada', number: '10', 
                neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                state: 'SP', zip_code: '05616-090'})
    another_user.create_inn!(brand_name: 'Pousada Teste 2', 
                registration_number: '582779834230198', 
                phone_number: '(11) 564651321', checkin_time: '18:00',
                checkout_time: '11:00', address_attributes: {
                  street_name: 'Av. da Pousada', number: '10', 
                  neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                  state: 'SP', zip_code: '05616-090'})
    room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                  max_capacity: 2, rent_price: 50, status: :active)

    # act
    login_as another_user
    patch inn_room_path(inn.id, room.id, room:  {name: 'lorem ipsum'})

    # assert
    expect(response).to redirect_to root_path
  end
end