require 'spec_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user_with_boards)
    @pins = @user.pins
  end

  after(:each) do
    if !@user.destroyed?
      @user.pins.destroy_all
      @user.boards.destroy_all
      @user.destroy
    end
  end

  it "renders attributes in <p>" do
    render
    @user.pins.each do |pin|
      expect(rendered).to match(pin.title)
    end
  end
end
