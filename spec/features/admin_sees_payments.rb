require 'spec_helper'

feature "Admin sees payments" do
  given(:john_the_admin) {Fabricate(:user, email: "john@example.com", password: "admins-rule", full_name: "John J. Admin", admin: true)}
  given(:pepper_the_user) {Fabricate(:user, email: "ppots@stark.com", password: "iron", full_name: "Pepper Potts")}
  background do 
    Fabricate(:payment, user: pepper_the_user, amount: 1995)
  end

  scenario "admin can see the listing of recent payments" do
    feature_sign_in(john_the_admin)
    visit(admin_payments_path)
    expect(page).to have_content('$19.95')
    expect(page).to have_content('Pepper Potts')
    
  end
  

end
