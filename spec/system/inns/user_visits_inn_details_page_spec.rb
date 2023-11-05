require 'rails_helper'

describe 'User visits the inn details page' do
  it 'and sees the inn data' do
    # arrange
    billy = User.create!(email: 'billy@mail.com', password: 'password')
    billy_inn = billy.create_inn!(brand_name: 'Pousada do Billy', 
                                registration_number: '94466613000162',
                                phone_number: '(11) 98765-4321',
                                checkin_time: '20:00', checkout_time: '12:00',
                                address_attributes: {street_name: 'Rua do Billy',
                                number: '10C', neighborhood: 'ABC',
                                city: 'Mongaguá', state: 'SP',
                                zip_code: '16000-000'})
    
    # act
    visit inn_path(billy_inn.id)

    # assert
    expect(page).to have_content 'Sobre a pousada'
    expect(page).to have_content 'Telefone para contato: (11) 98765-4321'
    expect(page).to have_content 'Horário de check-in: 20:00'
    expect(page).to have_content 'Horário de check-out: 12:00'
    expect(page).to have_content 'Endereço'
    expect(page).to have_content 'Rua do Billy, 10C'
    expect(page).to have_content 'ABC, Mongaguá - SP'
    expect(page).to have_content 'CEP: 16000-000'
  end

  it "and sees the policies for a pet friendly inn" do
    # arrange
    billy = User.create!(email: 'billy@mail.com', password: 'password')
    billy_inn = billy.create_inn!(brand_name: 'Pousada do Billy', 
                                registration_number: '94466613000162',
                                phone_number: '(11) 98765-4321',
                                checkin_time: '20:00', checkout_time: '12:00',
                                description: 'Linda pousada em frente à praia',
                                pet_friendly: true, 
                                policy: 'Não permitimos fumantes. Não permitimos festas.',
                                address_attributes: {street_name: 'Rua do Billy',
                                number: '10C', neighborhood: 'ABC',
                                city: 'Mongaguá', state: 'SP',
                                zip_code: '16000-000'})
    
    # act
    visit inn_path(billy_inn.id)

    # assert
  
    expect(page).to have_content 'Linda pousada em frente à praia'
    expect(page).to have_content 'Aceita animais de estimação'
    expect(page).to have_content 'Informações adicionais: Não permitimos fumantes. Não permitimos festas.'
  end

  it "and sees the policies for a non-pet friendly inn" do
    # arrange
    billy = User.create!(email: 'billy@mail.com', password: 'password')
    billy_inn = billy.create_inn!(brand_name: 'Pousada do Billy', 
                                registration_number: '94466613000162',
                                phone_number: '(11) 98765-4321',
                                checkin_time: '20:00', checkout_time: '12:00',
                                description: 'Linda pousada em frente à praia',
                                pet_friendly: false, 
                                policy: 'Não permitimos fumantes. Não permitimos festas.',
                                address_attributes: {street_name: 'Rua do Billy',
                                number: '10C', neighborhood: 'ABC',
                                city: 'Mongaguá', state: 'SP',
                                zip_code: '16000-000'})
    
    # act
    visit inn_path(billy_inn.id)

    # assert
  
    expect(page).to have_content 'Linda pousada em frente à praia'
    expect(page).to have_content 'Não aceita animais de estimação'
    expect(page).to have_content 'Informações adicionais: Não permitimos fumantes. Não permitimos festas.'
  end

  it 'and sees a warning for an inn without informed policies' do
    # arrange
    billy = User.create!(email: 'billy@mail.com', password: 'password')
    billy_inn = billy.create_inn!(brand_name: 'Pousada do Billy', 
                                registration_number: '94466613000162',
                                phone_number: '(11) 98765-4321',
                                checkin_time: '20:00', checkout_time: '12:00',
                                address_attributes: {street_name: 'Rua do Billy',
                                number: '10C', neighborhood: 'ABC',
                                city: 'Mongaguá', state: 'SP',
                                zip_code: '16000-000'})
    
    # act
    visit inn_path(billy_inn.id)

    # assert
    expect(page).to have_content 'Ainda não foram informadas as políticas desse local.'
  end

  it "and doesn't see the edit inn button if not authenticated" do
    # arrange
    billy = User.create!(email: 'billy@mail.com', password: 'password')
    billy_inn = billy.create_inn!(brand_name: 'Pousada do Billy', 
                                registration_number: '94466613000162',
                                phone_number: '(11) 98765-4321',
                                checkin_time: '20:00', checkout_time: '12:00',
                                address_attributes: {street_name: 'Rua do Billy',
                                number: '10C', neighborhood: 'ABC',
                                city: 'Mongaguá', state: 'SP',
                                zip_code: '16000-000'})

    # act
    visit inn_path(billy_inn.id)

    # assert
    expect(page).not_to have_link 'Editar', href: edit_inn_path(billy_inn.id)
  end

  it 'and returns to homepage' do
    # arrange
    billy = User.create!(email: 'billy@mail.com', password: 'password')
    billy_inn = billy.create_inn!(brand_name: 'Pousada do Billy', 
                                registration_number: '94466613000162',
                                phone_number: '(11) 98765-4321',
                                checkin_time: '20:00', checkout_time: '12:00',
                                address_attributes: {street_name: 'Rua do Billy',
                                number: '10C', neighborhood: 'ABC',
                                city: 'Mongaguá', state: 'SP',
                                zip_code: '16000-000'})
    
    # act
    visit inn_path(billy_inn.id)
    click_on 'Pousadaria'

    # assert
    expect(current_path).to eq root_path
  end

  it 'and sees a list of the available rooms' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'})
    room_a = inn.rooms.create!(name: 'Bedroom #1', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :active)
    room_b = inn.rooms.create!(name: 'Bedroom #2', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :active)
    room_c = inn.rooms.create!(name: 'Bedroom #3', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :inactive)
    room_d = inn.rooms.create!(name: 'Bedroom #4', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :active)
    room_e = inn.rooms.create!(name: 'Bedroom #5', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :inactive)
    
    # act
    visit inn_path(inn.id)
    
    # assert
    expect(page).to have_link 'Bedroom #1', href: inn_room_path(inn.id, room_a.id)
    expect(page).to have_link 'Bedroom #2', href: inn_room_path(inn.id, room_b.id)
    expect(page).not_to have_link 'Bedroom #3', href: inn_room_path(inn.id, room_c.id)
    expect(page).to have_link 'Bedroom #4', href: inn_room_path(inn.id, room_d.id)
    expect(page).not_to have_link 'Bedroom #5', href: inn_room_path(inn.id, room_e.id)
  end

  it 'sees a warning of no available rooms in this inn' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'})
    room_a = inn.rooms.create!(name: 'Bedroom #1', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :inactive)
    room_b = inn.rooms.create!(name: 'Bedroom #2', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :inactive)
    room_c = inn.rooms.create!(name: 'Bedroom #3', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :inactive)
    room_d = inn.rooms.create!(name: 'Bedroom #4', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :inactive)
    room_e = inn.rooms.create!(name: 'Bedroom #5', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :inactive)
    
    # act
    visit inn_path(inn.id)
    
    # assert
    expect(page).not_to have_link 'Bedroom #1', href: inn_room_path(inn.id, room_a.id)
    expect(page).not_to have_link 'Bedroom #2', href: inn_room_path(inn.id, room_b.id)
    expect(page).not_to have_link 'Bedroom #3', href: inn_room_path(inn.id, room_c.id)
    expect(page).not_to have_link 'Bedroom #4', href: inn_room_path(inn.id, room_d.id)
    expect(page).not_to have_link 'Bedroom #5', href: inn_room_path(inn.id, room_e.id)
    expect(page).to have_content 'A pousada não possui quartos disponíveis para consulta.'
  end
end
