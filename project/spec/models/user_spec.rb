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

  it "position_grade" do
    web_owner = create(:user, position: "web_owner")
    web_admin = create(:user, position: "web_admin")
    user = create(:user, position: "user")

    expect(web_owner.position_grade).to eq(5)
    expect(web_admin.position_grade).to eq(4)
    expect(user.position_grade).to eq(1)
  end

end
