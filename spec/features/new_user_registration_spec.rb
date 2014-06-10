require 'spec_helper'

feature "New User Registration" do
  background {visit register_path}
  scenario "with valid user data and valid credit card", {vcr: true, js: true} do
    enter_valid_user
    enter_valid_credit_card
    click_button "Sign Up"
    expect(page).to have_content("Thank you for registering with my flix")
  end

  scenario "with invalid user data and valid credit card", {vcr: true, js: true} do
    enter_invalid_user
    enter_valid_credit_card
    click_button "Sign Up"
    expect(page).to have_content("Error Processing your registration")
  end

  scenario "with valid user data and invalid credit card", {vcr: true, js: true} do
    enter_valid_user
    enter_invalid_card
    click_button "Sign Up"
    expect(page).to have_content("Your card's security code is invalid")
  end

  scenario "with valid user data and declined credit card", {vcr: true, js: true} do
    enter_valid_user
    enter_declined_card
    click_button "Sign Up"
    expect(page).to have_content("Your card was declined")
  end
  
  scenario "with invalid user data and invalid credit card", {vcr: true, js: true} do
    enter_invalid_user
    enter_invalid_card
    click_button "Sign Up"
    expect(page).to have_content("Your card's security code is invalid")
  end

  scenario "with invalid user data and declined credit card", {vcr: true, js: true} do
    enter_invalid_user
    enter_declined_card
    click_button "Sign Up"
    expect(page).to have_content("Error Processing your registration")
  end
  
  def enter_valid_user
    fill_in('Email Address', with: 'LCK@stars.com')
    fill_in('Full Name', with: 'Louis C.K.')
    fill_in('Password', with: 'secret')
  end
  
  def enter_valid_credit_card
    fill_in('Credit Card Number', with: '4242424242424242')
    fill_in('Security Code', with: '1234')
    select "7 - July", from: "date_month"
    select (Time.now.year+1).to_s, from: "date_year"
  end
  
  def enter_invalid_user
    fill_in('Email Address', with: '')
    fill_in('Full Name', with: 'Louis C.K.')
    fill_in('Password', with: 'secret')
  end
  
  def enter_invalid_card
    fill_in('Credit Card Number', with: '4242424242424242')
    fill_in('Security Code', with: '')
    select "7 - July", from: "date_month"
    select (Time.now.year+1).to_s, from: "date_year"
  end
  
  def enter_declined_card
    fill_in('Credit Card Number', with: '4000000000000341')
    fill_in('Security Code', with: '1234')
    select "7 - July", from: "date_month"
    select (Time.now.year+1).to_s, from: "date_year"
  end
end