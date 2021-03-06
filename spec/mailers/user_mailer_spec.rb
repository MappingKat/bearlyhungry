require './spec/spec_helper'

describe User do
  before(:each) do
    I18n.enforce_available_locales = false
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @user = FactoryGirl.build(:user, id: 1,
                                      full_name: "Antony THEMAN",
                                      email: "asdf@example.com",
                                      password: "password",
                                      password_confirmation: "password",
                                      display_name: "A DAWG",
                                      phone_number: "7742398699"
                                      )

     @order = FactoryGirl.create(:order)
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  it 'should send a sign up email on user creation' do
    @user.save
    ActionMailer::Base.deliveries.count.should == 1
  end

  context "sidekiq is working..." do
    it 'should have one job' do
      pending
      @user.save
      expect(UserMailerWorker).to have(1).enqueued.jobs
    end
  end
end
