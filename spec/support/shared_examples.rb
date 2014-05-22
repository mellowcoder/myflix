shared_examples "require_sign_in" do
  it "redirects to the sign in page" do
    logout_current_user
    action
    expect(response).to redirect_to(sign_in_path)
  end
end