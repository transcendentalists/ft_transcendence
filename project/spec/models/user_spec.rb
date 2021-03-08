require 'rails_helper'

describe "user test" do
  it "generate test" do
    user = create(:user)
    expect(user.persisted?).to eq(true)
  end
end
