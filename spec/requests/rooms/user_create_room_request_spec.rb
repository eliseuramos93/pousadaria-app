require 'rails_helper'

describe 'User requests to create an inn' do
  it 'but must be authenticated' do
    # arrange
    foo_inn_id = 910283091820931
    foo_room_id = 109283091275891
    
    # act
    post inn_rooms_path(foo_inn_id, room: {name: 'any_room'})

    # assert
    expect(response).to redirect_to new_user_session_path
  end

  it 'but must be a host user to have authorization' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :regular)
    foo_inn_id = 910283091820931
    foo_room_id = 109283091275891

    # act
    login_as user
    post inn_rooms_path(foo_inn_id, foo_room_id, room: {name: 'any room name'})

    # assert
    expect(response).to redirect_to root_path
  end
end