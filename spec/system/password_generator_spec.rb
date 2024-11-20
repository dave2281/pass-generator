require 'rails_helper'

RSpec.describe 'Password Generator', type: :system do
  before do
    driven_by(:selenium_chrome)
  end

  it 'renders the password generator form' do
    visit root_path

    expect(page).to have_selector('h1', text: 'Password Generator')

    expect(page).to have_selector('textarea#passwordField')

    expect(page).to have_button('Скопировать')

    expect(page).to have_selector('input#length')
  end

  it 'generates a password and updates the form' do
    visit root_path

    click_button 'Сгенерировать пароль'

    password_field = find('#passwordField')
    expect(password_field.value).not_to be_empty
  end

  it 'copies the password to clipboard', js: true do
    visit root_path

    click_button 'Скопировать'

    expect(page).to have_selector('#copyNotification', visible: true)
  end
end
