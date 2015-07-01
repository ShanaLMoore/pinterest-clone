require 'spec_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @pins = @user.pins
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

  it "renders attributes in <p>" do
    render
    @user.pins.each do |pin|
      expect(rendered).to match(pin.title)
    end
  end
end
