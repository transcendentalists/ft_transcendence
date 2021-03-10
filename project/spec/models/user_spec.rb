require 'rails_helper'

describe "user test" do
  it "can_service_manage?" do
    web_owner = create(:user, position: "web_owner")
    web_admin = create(:user, position: "web_admin")
    user = create(:user, position: "user")

    expect(web_owner.can_service_manage?).to eq(true)
    expect(web_admin.can_service_manage?).to eq(true)
    expect(user.can_service_manage?).to eq(false)
  end

end
