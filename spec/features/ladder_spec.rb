require 'spec_helper'

feature 'User can view the ladder' do
  let(:redis) { Redis.current }
  before(:each) do
    5.times do |n|
      player = build(:player, summoner_id: n, region: 'test')
      player.build_player_league(tier: 'CHALLENGER')
      player.save

      redis.zadd('rank_test', n, "#{n}_test")
      redis.zadd('rank_all', n, "#{n}_test")
    end
  end

  scenario 'Viewing the global ladder' do
    visit ladder_path('all')
    expect(page).to have_css('tr.ladder', count: 5)
  end
end