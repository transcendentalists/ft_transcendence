require "rails_helper"

describe "tournament test" do
  it "undercapacity test" do
    tournament, users = create_tournament({max: 8, register: 7})
    expect(tournament.memberships.count).to eq(7)
    start_tournament(tournament)
    expect(tournament.status).to eq("canceled")
    expect(all_tournament_membership_status(tournament)).to all( eq("canceled") )
  end
end
