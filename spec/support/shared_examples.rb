shared_examples "require_sign_in" do
  it "redirects to the sign in page" do
    logout_current_user
    action
    expect(response).to redirect_to(sign_in_path)
  end
end

shared_examples "tokened" do
  it "generates_random_token_on_create" do
    expect(object.token).to be_present
  end
  
end