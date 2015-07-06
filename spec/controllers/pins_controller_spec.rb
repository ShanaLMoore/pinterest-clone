require 'spec_helper'
RSpec.describe PinsController do
  before(:each) do
    @user = FactoryGirl.create(:user_with_boards)
    login(@user)
  end

  after(:each) do
    if !@user.destroyed?
      @user.pins.destroy_all
      @user.boards.destroy_all
      @user.destroy
    end
  end

  describe "GET index" do

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'populates @pins with all pins' do
      get :index
      expect(assigns[:pins]).to eq(Pin.all)
    end

    it 'redirects to login when not logged in' do
      logout(@user)
      get :index
      expect(response).to redirect_to(:login)
    end

  end

  describe "GET new" do
    it 'responds with successfully' do
      get :new
      expect(response.success?).to be(true)
    end

    it 'renders the new view' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns an instance variable to a new pin' do
      get :new
      expect(assigns(:pin)).to be_a_new(Pin)
    end

    it 'redirects to login when not logged in' do
      logout(@user)
      get :new
      expect(response).to redirect_to(:login)
    end
  end

  describe "POST create" do
    before(:each) do
      @pin_hash = {
        title: "spec Wizard",
        url: "http://specwizard.org",
        slug: "spec-wizard",
        text: "A fun and helpful spec Resource",
        category_id: 1}
    end

    after(:each) do
      pin = Pin.find_by_slug("spec-wizard")
      if !pin.nil?
        pin.destroy
      end
    end

    it 'responds with a redirect' do
      post :create, pin: @pin_hash
      expect(response.redirect?).to be(true)
    end

    it 'creates a pin' do
      post :create, pin: @pin_hash
      expect(Pin.find_by_slug("spec-wizard").present?).to be(true)
    end

    it 'redirects to the show view' do
      post :create, pin: @pin_hash
      expect(response).to redirect_to(pin_url(assigns(:pin)))
    end

    it 'redisplays new form on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash.delete(:title)
      post :create, pin: @pin_hash
      expect(response).to render_template(:new)
    end

    it 'assigns the @errors instance variable on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash.delete(:title)
      post :create, pin: @pin_hash
      expect(assigns[:errors].present?).to be(true)
    end

    it 'redirects to login when not logged in' do
      logout(@user)
      post :create, pin: @pin_hash
      expect(response).to redirect_to(:login)
    end

  end

  describe 'GET edit' do

    before(:each) do
      @pin_hash = {
        title: "spec Wizard",
        url: "http://specwizard.org",
        slug: "spec-wizard",
        text: "A fun and helpful spec Resource",
        category_id: 1}
    end

    after(:each) do
      pin = Pin.find_by_slug("spec-wizard")
      if !pin.nil?
        pin.destroy
      end
    end

    # get to pins/id/edit
    # responds successfully
    it 'responds with successfully' do
      get :edit, id: @pin_hash
      expect(response.success?).to be(true)
    end

    # renders the edit template
    it 'renders the edit view' do
      get :edit, id: @pin_hash
      expect(response).to render_template(:edit)
    end

    # assigns an intance variable called @pin to the Pin with the appropiate ID
    it 'assigns an instance variable to a existing pin' do
      get :edit, id: @pin_hash
      expect(assigns(:pin)).to eq(Pin.find_by_slug(@pin_hash[:slug]))
    end

    it 'redirects to login when not logged in' do
      logout(@user)
      get :edit, id: @pin_hash
      expect(response).to redirect_to(:login)
    end
  end

  describe 'PUT update' do

    before(:each) do
      @pin_hash = {  # this is the info for the form to edit
        title: "spec Wizard",
        url: "http://specwizard.org",
        slug: "spec-wizard",
        text: "A fun and helpful spec Resource",
        category_id: 1}

      @pin = Pin.create(  # had to create a pin so the test could edit it
        title: "spec Wizard",
        url: "http://specwizard.org",
        slug: "spec-wizard",
        text: "A fun and helpful spec Resource",
        category_id: 1)
    end

    after(:each) do
      pin = Pin.find_by_slug("spec-wizard")
      if !pin.nil?
        pin.destroy
      end
    end

    it 'responds with successfully' do
      put :update, pin: @pin_hash, id: @pin
      expect(response.redirect?).to be(true)
    end

    it 'updates a pin' do
      @pin_hash[:title] = "test"
      put :update, pin: @pin_hash, id: @pin
      expect(assigns(:pin)[:title]).to eq(@pin_hash[:title])
    end

    it 'redirect to show view' do
      put :update, pin: @pin_hash, id: @pin
      expect(response).to redirect_to(pin_url(assigns(:pin)))
    end

    it 'assigns the @errors instance variable on error' do
      @pin_hash[:title] = ""
      put :update, pin: @pin_hash, id: @pin
      expect(assigns[:errors].present?).to be(true)
    end

    it 'renders edit when there is an error' do
      @pin_hash[:title] = ""
      put :update, pin: @pin_hash, id: @pin
      expect(response).to render_template(:edit)
    end

    it 'redirects to login when not logged in' do
      logout(@user)
      get :update, pin: @pin_hash, id: @pin
      expect(response).to redirect_to(:login)
    end
  end

  describe "POST repin" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      login(@user)
      @pin = FactoryGirl.create(:pin)
    end

    after(:each) do
      user = User.all
      user.each do |u|
        if !u.destroyed?
          u.pins.destroy_all
          u.boards.destroy_all
          u.destroy
        end
      end

      pins = Pin.all
      pins.each do |pin|
        if !pin.destroyed?
          pin.destroy
        end
      end
    end

    it 'responds with a redirect' do
      post :repin, id: @pin.id
      expect(response.redirect?).to be(true)
    end

    it 'creates a user.pin' do
      post :repin, id: @pin.id
      expect(@user.pins.find(@pin.id).id).to eq(@pin.id)
    end

    it 'redirects to the user show page' do
      post :repin, id: @pin.id
      expect(response).to redirect_to(user_path(@user))
    end
  end

end
