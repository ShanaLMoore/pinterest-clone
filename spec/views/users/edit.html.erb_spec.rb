require 'spec_helper'

RSpec.describe "users/edit", type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  after(:each) do
    user = User.all
    user.each do |u|
      if !u.destroyed?
        u.destroy
      end
    end

    pin = Pin.where("title=?", "Rails Cheatsheet")
    pin.each do |p|
      if !p.destroyed?
        p.destroy
      end
    end

  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input#user_first_name[name=?]", "user[first_name]"

      assert_select "input#user_last_name[name=?]", "user[last_name]"

      assert_select "input#user_email[name=?]", "user[email]"

      assert_select "input#user_password[name=?]", "user[password]"
    end
  end
end
