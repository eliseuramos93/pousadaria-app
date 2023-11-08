# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


cassio = User.create!(email: 'cassioramos@gmail.com', password: 'password', 
                      role: 'host')
carlos = User.create!(email: 'carlosmiguel@gmail.com', password: 'password', 
                      role: 'host')
fabio = User.create!(email: 'fabiosantos@gmail.com', password: 'password', 
                     role: 'host')
bidu = User.create!(email: 'matheusbidu@gmail.com', password: 'password',
                    role: 'host')
fagner = User.create!(email: 'fagner@gmail.com', password: 'password',
                      role: 'host')
bruno = User.create!(email: 'brunomendez@gmail.com', password: 'password',
                     role: 'host')
caetano = User.create!(email: 'caetanoandrade@gmail.com', password: 'password',
                       role: 'host')
gil = User.create!(email: 'gilbertosilva@gmail.com', password: 'password',
                   role: 'host')
fausto = User.create!(email: 'faustovera@gmail.com', password: 'password',
                      role: 'host')
moscardo = User.create!(email: 'gabrielmoscardo@gmail.com', password: 'password',
                        role: 'host')

cassio_inn = cassio.create_inn!(brand_name: 'Pousada do Gigante', 
                                registration_number: '76858045000163',
                                phone_number: '(21) 92134-6789', 
                                checkin_time: '18:00', checkout_time: '11:00',
                                address_attributes: {
                                  street_name: 'Rua Paraguai', number: '112',
                                  neighborhood: 'Rio Branco', 
                                  city: 'Porto Alegre', state: 'RS',
                                  zip_code: '90420100'
                                }, pet_friendly: 'true', 
                                description: 'Aqui só entram visitantes.',
                                policy: 'Proibido entrar de verde, atacantes não são bem vindos.',
                                status: 'active')
cassio_inn.rooms.create!(name: 'Invasão no Japão', description: 'Nosso quarto premium',
                         area: 80, max_capacity: 6, rent_price: 199.99, 
                         status: 'active', has_bathroom: 'true', 
                         has_balcony: 'true', has_air_conditioner: 'true',
                         has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                         is_accessible: 'true')
cassio_inn.rooms.create!(name: 'Libertados', description: 'Nosso quarto de alto padrão',
                         area: 40, max_capacity: 4, rent_price: 99.99, 
                         status: 'active', has_bathroom: 'true', 
                         has_balcony: 'true', has_air_conditioner: 'true',
                         has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                         is_accessible: 'true')
cassio_inn.rooms.create!(name: 'Hepta de Respeito', description: 'Quarta força',
                         area: 20, max_capacity: 3, rent_price: 59.99, 
                         status: 'active', has_bathroom: 'true', 
                         has_balcony: 'true', has_air_conditioner: 'true',
                         has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                         is_accessible: 'true')

carlos_inn = carlos.create_inn!(brand_name: 'CM Pousada', 
                                registration_number: '55683692000101',
                                phone_number: '(51) 91234-6789', 
                                checkin_time: '18:00', checkout_time: '11:00',
                                address_attributes: {
                                  street_name: 'Beco São Judas Tadeu', number: '321',
                                  neighborhood: 'Bangu', 
                                  city: 'Rio de Janeiro', state: 'RJ',
                                  zip_code: '21820360'
                                }, pet_friendly: 'true', 
                                description: 'Uma tranquila pousada carioca.',
                                policy: 'Proibido gritar com os funcionários.',
                                status: 'active')
carlos_inn.rooms.create!(name: 'Reserva de Luxo', description: 'Nosso quarto premium',
                        area: 80, max_capacity: 6, rent_price: 199.99, 
                        status: 'active', has_bathroom: 'true', 
                        has_balcony: 'true', has_air_conditioner: 'true',
                        has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                        is_accessible: 'true')
carlos_inn.rooms.create!(name: 'Ponte aérea', description: 'Nosso quarto de alto padrão',
                        area: 40, max_capacity: 4, rent_price: 99.99, 
                        status: 'active', has_bathroom: 'true', 
                        has_balcony: 'true', has_air_conditioner: 'true',
                        has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                        is_accessible: 'true')
carlos_inn.rooms.create!(name: 'Que defesa!', description: 'Quarto padrão',
                        area: 20, max_capacity: 3, rent_price: 59.99, 
                        status: 'active', has_bathroom: 'true', 
                        has_balcony: 'true', has_air_conditioner: 'true',
                        has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                        is_accessible: 'true')


fabio_inn = fabio.create_inn!(brand_name: 'Avenida Esquerda', 
                                registration_number: '93263437000107',
                                phone_number: '(11) 91234-6897', 
                                checkin_time: '18:00', checkout_time: '11:00',
                                address_attributes: {
                                  street_name: 'Rua dos Aliados', number: '662',
                                  neighborhood: 'Alto da Lapa', 
                                  city: 'São Paulo', state: 'SP',
                                  zip_code: '05082001'
                                }, pet_friendly: 'false', 
                                description: 'Para você que gosta de exibir sua coxa.',
                                policy: 'Proibido ter cabelo.',
                                status: 'active')
fabio_inn.rooms.create!(name: 'Aposentadoria de Luxo', description: 'Nosso quarto premium',
                        area: 80, max_capacity: 6, rent_price: 199.99, 
                        status: 'active', has_bathroom: 'true', 
                        has_balcony: 'true', has_air_conditioner: 'true',
                        has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                        is_accessible: 'true')
fabio_inn.rooms.create!(name: 'Penalti certeiro', description: 'Nosso quarto de alto padrão',
                        area: 40, max_capacity: 4, rent_price: 99.99, 
                        status: 'active', has_bathroom: 'true', 
                        has_balcony: 'true', has_air_conditioner: 'true',
                        has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                        is_accessible: 'true')
fabio_inn.rooms.create!(name: 'Passagem Livre', description: 'Quarto padrão',
                        area: 20, max_capacity: 3, rent_price: 59.99, 
                        status: 'active', has_bathroom: 'true', 
                        has_balcony: 'true', has_air_conditioner: 'true',
                        has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                        is_accessible: 'true')

bidu_inn = bidu.create_inn!(brand_name: 'Sobe e Não Volta Inn', 
                            registration_number: '34216448000169',
                            phone_number: '(11) 96887-6897', 
                            checkin_time: '18:00', checkout_time: '11:00',
                            address_attributes: {
                              street_name: 'Rua Voluntários da Pátria', 
                              number: '3122', neighborhood: 'Santana', 
                              city: 'São Paulo', state: 'SP',
                              zip_code: '02010400'
                            }, pet_friendly: 'false', 
                            description: 'Nós só pensamos lá na frente',
                            policy: 'Não cancelamos reservas: proibido voltar atrás.',
                            status: 'active')
bidu_inn.rooms.create!(name: 'Apoio ofensivo de elite', description: 'Nosso quarto premium',
                       area: 80, max_capacity: 6, rent_price: 199.99, 
                       status: 'active', has_bathroom: 'true', 
                       has_balcony: 'true', has_air_conditioner: 'true',
                       has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                       is_accessible: 'true')
bidu_inn.rooms.create!(name: 'Descanso pós-subida', description: 'Nosso quarto de alto padrão',
                       area: 40, max_capacity: 4, rent_price: 99.99, 
                       status: 'active', has_bathroom: 'true', 
                       has_balcony: 'true', has_air_conditioner: 'true',
                       has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                       is_accessible: 'true')
bidu_inn.rooms.create!(name: 'Área de marcação', description: 'Quarto padrão',
                       area: 20, max_capacity: 3, rent_price: 59.99, 
                       status: 'active', has_bathroom: 'true', 
                       has_balcony: 'true', has_air_conditioner: 'true',
                       has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                       is_accessible: 'true')
                            

fagner_inn = fagner.create_inn!(brand_name: 'Ex-Seleção Pousada', 
                          registration_number: '84315504000190',
                          phone_number: '(11) 96887-6897', 
                          checkin_time: '18:00', checkout_time: '11:00',
                          address_attributes: {
                            street_name: 'Avenida do Rio Bonito', 
                            number: '1589', neighborhood: 'Socorro', 
                            city: 'São Paulo', state: 'SP',
                            zip_code: '04776001'
                          }, pet_friendly: 'true', 
                          description: 'Um choque forte de experiência',
                          policy: 'Do pescoço pra baixo, é canela.',
                          status: 'active')
fagner_inn.rooms.create!(name: 'Seleção Brasileira', description: 'Nosso quarto premium',
                        area: 80, max_capacity: 6, rent_price: 199.99, 
                        status: 'active', has_bathroom: 'true', 
                        has_balcony: 'true', has_air_conditioner: 'true',
                        has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                        is_accessible: 'true')
fagner_inn.rooms.create!(name: 'Chegada Firme', description: 'Nosso quarto de alto padrão',
                        area: 40, max_capacity: 4, rent_price: 99.99, 
                        status: 'active', has_bathroom: 'true', 
                        has_balcony: 'true', has_air_conditioner: 'true',
                        has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                        is_accessible: 'true')
fagner_inn.rooms.create!(name: 'Cruzamento certeiro', description: 'Quarto padrão',
                        area: 20, max_capacity: 3, rent_price: 59.99, 
                        status: 'active', has_bathroom: 'true', 
                        has_balcony: 'true', has_air_conditioner: 'true',
                        has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                        is_accessible: 'true')

bruno_inn = bruno.create_inn!(brand_name: 'Erva Mate e Carrinho BNB', 
                              registration_number: '54037392000192',
                              phone_number: '(51) 96823-6897', 
                              checkin_time: '18:00', checkout_time: '11:00',
                              address_attributes: {
                                street_name: 'Rua Domingos Manoel Mincarone', 
                                number: '3265', neighborhood: 'Restinga', 
                                city: 'Porto Alegre', state: 'RS',
                                zip_code: '91790101'
                              }, pet_friendly: 'true', 
                              description: 'Uma pousada com toque uruguaio.',
                              policy: 'Não fazemos renovações de aluguéis',
                              status: 'active')
bruno_inn.rooms.create!(name: 'Seleción Uruguaya', description: 'Nosso quarto premium',
                        area: 80, max_capacity: 6, rent_price: 199.99, 
                        status: 'active', has_bathroom: 'true', 
                        has_balcony: 'true', has_air_conditioner: 'true',
                        has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                        is_accessible: 'true')
bruno_inn.rooms.create!(name: 'Mate y Ocio', description: 'Nosso quarto de alto padrão',
                        area: 40, max_capacity: 4, rent_price: 99.99, 
                        status: 'active', has_bathroom: 'true', 
                        has_balcony: 'true', has_air_conditioner: 'true',
                        has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                        is_accessible: 'true')
bruno_inn.rooms.create!(name: 'Sin Negociación', description: 'Quarto padrão',
                        area: 20, max_capacity: 3, rent_price: 59.99, 
                        status: 'active', has_bathroom: 'true', 
                        has_balcony: 'true', has_air_conditioner: 'true',
                        has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                        is_accessible: 'true')

caetano_inn = caetano.create_inn!(brand_name: 'Pousada do Futuro', 
                                  registration_number: '29742570000139',
                                  phone_number: '(21) 94436-7123', 
                                  checkin_time: '18:00', checkout_time: '11:00',
                                  address_attributes: {
                                    street_name: 'Rua Comandante Coelho', 
                                    number: '3265', neighborhood: 'Cordovil', 
                                    city: 'Rio de Janeiro', state: 'RJ',
                                    zip_code: '21250510'
                                  }, pet_friendly: 'true', 
                                  description: 'Uma pousada moderna e confortável',
                                  policy: 'Só aceitamos reservas futuras',
                                  status: 'active')
caetano_inn.rooms.create!(name: 'Maria Bethania', description: 'Nosso quarto premium',
                          area: 80, max_capacity: 6, rent_price: 199.99, 
                          status: 'active', has_bathroom: 'true', 
                          has_balcony: 'true', has_air_conditioner: 'true',
                          has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                          is_accessible: 'true')
caetano_inn.rooms.create!(name: 'Gilberto Gil', description: 'Nosso quarto de alto padrão',
                          area: 40, max_capacity: 4, rent_price: 99.99, 
                          status: 'active', has_bathroom: 'true', 
                          has_balcony: 'true', has_air_conditioner: 'true',
                          has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                          is_accessible: 'true')
caetano_inn.rooms.create!(name: 'Gal Costa', description: 'Quarto padrão',
                          area: 20, max_capacity: 3, rent_price: 59.99, 
                          status: 'active', has_bathroom: 'true', 
                          has_balcony: 'true', has_air_conditioner: 'true',
                          has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                          is_accessible: 'true')

gil_inn = gil.create_inn!(brand_name: 'Pousada da Goiabeira', 
                          registration_number: '88570459000171',
                          phone_number: '(21) 95566-7892', 
                          checkin_time: '18:00', checkout_time: '11:00',
                          address_attributes: {
                            street_name: 'Rua H', 
                            number: '53', neighborhood: 'Maré', 
                            city: 'Rio de Janeiro', state: 'RJ',
                            zip_code: '21044570'
                          }, pet_friendly: 'false', 
                          description: 'Um paraíso verde, cheio de árvores',
                          policy: 'Proibido roubar as goiabas.',
                          status: 'active')
gil_inn.rooms.create!(name: 'Jesus na Goiabera', description: 'Nosso quarto premium',
                      area: 80, max_capacity: 6, rent_price: 199.99, 
                      status: 'active', has_bathroom: 'true', 
                      has_balcony: 'true', has_air_conditioner: 'true',
                      has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                      is_accessible: 'true')
gil_inn.rooms.create!(name: 'Penalti no Ronaldo', description: 'Nosso quarto de alto padrão',
                      area: 40, max_capacity: 4, rent_price: 99.99, 
                      status: 'active', has_bathroom: 'true', 
                      has_balcony: 'true', has_air_conditioner: 'true',
                      has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                      is_accessible: 'true')
gil_inn.rooms.create!(name: 'Cobertura monstra', description: 'Quarto padrão',
                      area: 20, max_capacity: 3, rent_price: 59.99, 
                      status: 'active', has_bathroom: 'true', 
                      has_balcony: 'true', has_air_conditioner: 'true',
                      has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                      is_accessible: 'true')

fausto_inn = fausto.create_inn!(brand_name: 'Pouco Resultado Inn', 
                                registration_number: '51547503000112',
                                phone_number: '(67) 92218-0983', 
                                checkin_time: '18:00', checkout_time: '11:00',
                                address_attributes: {
                                  street_name: 'Rua Coronel Ponciano de Mattos Pereira', 
                                  number: '3265', neighborhood: 'Jardim dos Estados', 
                                  city: 'Dourados', state: 'MS',
                                  zip_code: '79831230'
                                }, pet_friendly: 'false', 
                                description: 'Uma pousada para você parar, refletir, e tocar para trás',
                                policy: 'Proibido seguir adiante',
                                status: 'active')
fausto_inn.rooms.create!(name: 'Portunhol Acelerado', description: 'Nosso quarto premium',
                          area: 80, max_capacity: 6, rent_price: 199.99, 
                          status: 'active', has_bathroom: 'true', 
                          has_balcony: 'true', has_air_conditioner: 'true',
                          has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                          is_accessible: 'true')
fausto_inn.rooms.create!(name: 'Passe para Trás', description: 'Nosso quarto de alto padrão',
                          area: 40, max_capacity: 4, rent_price: 99.99, 
                          status: 'active', has_bathroom: 'true', 
                          has_balcony: 'true', has_air_conditioner: 'true',
                          has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                          is_accessible: 'true')
fausto_inn.rooms.create!(name: 'Hablou, gamou', description: 'Quarto padrão',
                          area: 20, max_capacity: 3, rent_price: 59.99, 
                          status: 'active', has_bathroom: 'true', 
                          has_balcony: 'true', has_air_conditioner: 'true',
                          has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                          is_accessible: 'true')

moscardo_inn = moscardo.create_inn!(brand_name: 'Pousada Universitária', 
                                    registration_number: '70897553000174',
                                    phone_number: '(11) 92155-7957', 
                                    checkin_time: '18:00', checkout_time: '11:00',
                                    address_attributes: {
                                      street_name: 'Rua Manoel Antônio Gonçalves Bastos', 
                                      number: '1864', neighborhood: 'Jardim São Paulo (Zona Leste)', 
                                      city: 'São Paulo', state: 'SP',
                                      zip_code: '08461630'
                                    }, pet_friendly: 'false', 
                                    description: 'Pousada direcionada para o público jovem',
                                    policy: 'Pousada exclusiva para universitários',
                                    status: 'active')
moscardo_inn.rooms.create!(name: 'Portunhol Acelerado', description: 'Nosso quarto premium',
                            area: 80, max_capacity: 6, rent_price: 199.99, 
                            status: 'active', has_bathroom: 'true', 
                            has_balcony: 'true', has_air_conditioner: 'true',
                            has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                            is_accessible: 'true')
moscardo_inn.rooms.create!(name: 'Passe para Trás', description: 'Nosso quarto de alto padrão',
                            area: 40, max_capacity: 4, rent_price: 99.99, 
                            status: 'active', has_bathroom: 'true', 
                            has_balcony: 'true', has_air_conditioner: 'true',
                            has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                            is_accessible: 'true')
moscardo_inn.rooms.create!(name: 'Hablou, gamou', description: 'Quarto padrão',
                            area: 20, max_capacity: 3, rent_price: 59.99, 
                            status: 'active', has_bathroom: 'true', 
                            has_balcony: 'true', has_air_conditioner: 'true',
                            has_tv: 'true', has_wardrobe: 'true', has_vault: 'false',
                            is_accessible: 'true')
