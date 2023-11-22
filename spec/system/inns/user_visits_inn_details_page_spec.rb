require 'rails_helper'

describe 'User visits the inn details page' do
  it 'only when the inn is active' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'}, status: 'inactive')

    # act
    visit inn_path(inn)

    # assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'A página não está disponível'
  end

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
                                zip_code: '16000-000'}, status: 'active')
    
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
                                zip_code: '16000-000'}, status: 'active')
    
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
                                zip_code: '16000-000'}, status: 'active')
    
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
                                zip_code: '16000-000'}, status: 'active')
    
    # act
    visit inn_path(billy_inn.id)

    # assert
    expect(page).to have_content 'Ainda não foram informadas as políticas desse local.'
  end

  it "and doesn't see the owner section if not authenticated" do
    # arrange
    user = User.create!(email: 'billy@mail.com', password: 'password')
    inn = user.create_inn!(brand_name: 'Pousada do Billy', 
                                registration_number: '94466613000162',
                                phone_number: '(11) 98765-4321',
                                checkin_time: '20:00', checkout_time: '12:00',
                                address_attributes: {street_name: 'Rua do Billy',
                                number: '10C', neighborhood: 'ABC',
                                city: 'Mongaguá', state: 'SP',
                                zip_code: '16000-000'})

    # act
    visit inn_path(inn)

    # assert
    expect(page).not_to have_button 'Marcar como Indisponível'
    expect(page).not_to have_link 'Editar Pousada', href: edit_inn_path(inn)
    expect(page).not_to have_link 'Adicionar Quarto', href: new_inn_room_path(inn)
    expect(page).not_to have_link 'Ver Meus Quartos', href: inn_rooms_path(inn)
  end

  it "and doesn't see the owner section if the inn does not belong to him/her" do
    # arrange
    user_a = User.create!(email: 'andre@gmail.com', password: 'password', 
                      role: 'host')
    user_b = User.create!(email: 'bento@gmail.com', password: 'password', 
                      role: 'host')

    inn_a = user_a.create_inn!(brand_name: "Pousada do André", 
                        registration_number: '12345612318', 
                        phone_number: '(11) 109238019', 
                        checkin_time: '19:00', checkout_time: '12:00',
                        address_attributes: {
                          street_name: 'Av. Angelica', number: '1',
                          neighborhood: 'Bairro A', city: 'São Paulo',
                          state: 'SP', zip_code: '01000-000' },
                        status: 'active')
    inn_b = user_b.create_inn!(brand_name: "BNB do Bento", 
                         registration_number: '18273981731', 
                         phone_number: '(11) 189237189', 
                         checkin_time: '20:00', checkout_time: '11:00',
                         address_attributes: {
                            street_name: 'R. Birigui', number: '12',
                            neighborhood: 'Bairro B', city: 'São Paulo',
                            state: 'SP', zip_code: '02000-000' },
                         status: 'inactive')

    # act
    login_as user_b
    visit inn_path(inn_a)

    # assert
    expect(page).not_to have_button 'Marcar como Indisponível'
    expect(page).not_to have_link 'Editar Pousada', href: edit_inn_path(inn_a)
    expect(page).not_to have_link 'Adicionar Quarto', href: new_inn_room_path(inn_a)
    expect(page).not_to have_link 'Ver Meus Quartos', href: inn_rooms_path(inn_a)
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
                        state: 'SP', zip_code: '05616-090'}, status: 'active')
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
    expect(page).to have_link 'Bedroom #1', href: room_path(room_a.id)
    expect(page).to have_link 'Bedroom #2', href: room_path(room_b.id)
    expect(page).not_to have_link 'Bedroom #3', href: room_path(room_c.id)
    expect(page).to have_link 'Bedroom #4', href: room_path(room_d.id)
    expect(page).not_to have_link 'Bedroom #5', href: room_path(room_e.id)
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
                        state: 'SP', zip_code: '05616-090'}, status: 'active')

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
    expect(page).not_to have_link 'Bedroom #1', href: room_path(room_a.id)
    expect(page).not_to have_link 'Bedroom #2', href: room_path(room_b.id)
    expect(page).not_to have_link 'Bedroom #3', href: room_path(room_c.id)
    expect(page).not_to have_link 'Bedroom #4', href: room_path(room_d.id)
    expect(page).not_to have_link 'Bedroom #5', href: room_path(room_e.id)
    expect(page).to have_content 'A pousada não possui quartos disponíveis para consulta.'
  end
end
