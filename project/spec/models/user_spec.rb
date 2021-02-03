require 'rails_helper'

RSpec.describe User, type: :model do
  it "is not valid without name" do
    expect(User.new.name).to be_nil
  end
end
