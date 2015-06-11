require "spec_helper"

RSpec.describe "Our Application Routes" do
  describe "Get /pins/name-:slug" do
    
    it 'renders the pins/show templates' do
      pin = Pin.first
      get "/pins/name-#{pin.slug}"
      expect(response).to render_template("pins/show")
    end

    it 'populates the @pin variable with the appropriate pin' do
      pin = Pin.first
      get "/pins/name-#{pin.slug}"
      expect(assigns[:pin]).to eq(pin)
    end

  end
end
