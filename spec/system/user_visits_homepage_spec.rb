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
end