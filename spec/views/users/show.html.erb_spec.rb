require 'spec_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  after(:each) do
    if !@user.destroyed?
      @user.destroy
    end
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(@user.first_name)
    expect(rendered).to match(@user.last_name)
    expect(rendered).to match(@user.email)
  end
end
