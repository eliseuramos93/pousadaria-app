require 'rails_helper'

describe 'User visits homepage' do
  it 'and sees the name of the application' do
    # arrange

    # act
    visit root_path

    # assert
    expect(page).to have_content 'Pousadaria'
  end

  it 'and sees a link to create a new inn owner account' do
    # arrange

    # act
    visit root_path

    # assert
    expect(page).to have_link 'Seja um Pousadeiro', 
                               href: new_user_registration_path
  end

  it 'and sees a list of links for the three most recent active inns' do
    # arrange
    user_a = User.create!(email: 'andre@gmail.com', password: 'password', 
                      role: 'host')
    user_b = User.create!(email: 'bento@gmail.com', password: 'password', 
                      role: 'host')
    user_c = User.create!(email: 'celso@gmail.com', password: 'password', 
                      role: 'host')
    user_d = User.create!(email: 'diego@gmail.com', password: 'password',
                      role: 'host')
    user_e = User.create!(email: 'elisa@gmail.com', password: 'password',
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
                               status: 'active')
    inn_c = user_c.create_inn!(brand_name: "Canto do Celso", 
                               registration_number: '18273981731', 
                               phone_number: '(11) 189237189', 
                               checkin_time: '20:00', checkout_time: '11:00',
                               address_attributes: {
                                  street_name: 'R. Cubatão', number: '33',
                                  neighborhood: 'Bairro C', city: 'São Paulo',
                                  state: 'SP', zip_code: '03000-000' },
                               status: 'active')
    inn_d = user_d.create_inn!(brand_name: "Divino do Diego", 
                                registration_number: '1827398172398', 
                                phone_number: '(11) 189273891', 
                                checkin_time: '18:00', checkout_time: '10:00',
                                address_attributes: {
                                   street_name: 'R. Dourados', number: '45',
                                   neighborhood: 'Bairro D', city: 'Peruibe',
                                   state: 'SP', zip_code: '04000-000' },
                                status: 'active')
    inn_e = user_e.create_inn!(brand_name: "Estadia da Elisa", 
                                  registration_number: '89127398172398', 
                                  phone_number: '(11) 9182739', 
                                  checkin_time: '21:00', checkout_time: '13:00',
                                  address_attributes: {
                                     street_name: 'Av. Eliseu de Almeida', number: '500',
                                     neighborhood: 'Bairro E', city: 'Bragança Paulista',
                                     state: 'SP', zip_code: '04500-000' },
                                  status: 'active')

    # act
    visit root_path

    # assert
    within "#recent-inns" do
      expect(page).not_to have_link 'Pousada do André', href: inn_path(inn_a.id)
      expect(page).not_to have_link 'BNB do Bento', href: inn_path(inn_b.id)
      expect(page).to have_link 'Canto do Celso', href: inn_path(inn_c.id)
      expect(page).to have_content 'São Paulo'
      expect(page).to have_link 'Divino do Diego', href: inn_path(inn_d.id)
      expect(page).to have_content 'Peruibe'
      expect(page).to have_link 'Estadia da Elisa', href: inn_path(inn_e.id)
      expect(page).to have_content 'Bragança Paulista'
    end
  end

  it 'and sees the remaining inns in a separated list' do
    # arrange
    user_a = User.create!(email: 'andre@gmail.com', password: 'password', 
                      role: 'host')
    user_b = User.create!(email: 'bento@gmail.com', password: 'password', 
                      role: 'host')
    user_c = User.create!(email: 'celso@gmail.com', password: 'password', 
                      role: 'host')
    user_d = User.create!(email: 'diego@gmail.com', password: 'password',
                      role: 'host')
    user_e = User.create!(email: 'elisa@gmail.com', password: 'password',
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
                               status: 'active')
    inn_c = user_c.create_inn!(brand_name: "Canto do Celso", 
                               registration_number: '18273981731', 
                               phone_number: '(11) 189237189', 
                               checkin_time: '20:00', checkout_time: '11:00',
                               address_attributes: {
                                  street_name: 'R. Cubatão', number: '33',
                                  neighborhood: 'Bairro C', city: 'São Paulo',
                                  state: 'SP', zip_code: '03000-000' },
                               status: 'active')
    inn_d = user_d.create_inn!(brand_name: "Divino do Diego", 
                                registration_number: '1827398172398', 
                                phone_number: '(11) 189273891', 
                                checkin_time: '18:00', checkout_time: '10:00',
                                address_attributes: {
                                   street_name: 'R. Dourados', number: '45',
                                   neighborhood: 'Bairro D', city: 'São Paulo',
                                   state: 'SP', zip_code: '04000-000' },
                                status: 'active')
    inn_e = user_e.create_inn!(brand_name: "Estadia da Elisa", 
                                  registration_number: '89127398172398', 
                                  phone_number: '(11) 9182739', 
                                  checkin_time: '21:00', checkout_time: '13:00',
                                  address_attributes: {
                                     street_name: 'Av. Eliseu de Almeida', number: '500',
                                     neighborhood: 'Bairro E', city: 'São Paulo',
                                     state: 'SP', zip_code: '04500-000' },
                                  status: 'active')

    # act
    visit root_path

    # assert
    within "#remaining-inns" do
      expect(page).to have_link 'Pousada do André', href: inn_path(inn_a.id)
      expect(page).to have_link 'BNB do Bento', href: inn_path(inn_b.id)
      expect(page).not_to have_link 'Canto do Celso', href: inn_path(inn_c.id)
      expect(page).not_to have_link 'Divino do Diego', href: inn_path(inn_d.id)
      expect(page).not_to have_link 'Estadia da Elisa', href: inn_path(inn_e.id)
    end
  end
end