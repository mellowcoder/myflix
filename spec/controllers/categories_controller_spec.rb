require 'spec_helper'

describe CategoriesController do

  describe "GET #show" do
    it_behaves_like "require_sign_in" do 
      before {Fabricate(:category)}
      let(:action) {get :show, id: Category.last}
    end
    
  end
end
