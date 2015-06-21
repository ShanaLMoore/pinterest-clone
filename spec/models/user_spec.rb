require 'spec_helper'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  describe "Function authenticate" do
    before(:all) do
      @user = User.create(email: "coder@skillcrush", password: "password")
    end

    after(:all) do
      if !@user.destroyed?
        @user.destroy
      end
    end

    it 'authenticates and returns a user when valid email and password passed in' do
      user = User.authenticate(@user.email, @user.password)
      expect(user).to eq(@user)
    end
  end
end
