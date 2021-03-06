require 'spec_helper'

describe Ladder do
  before(:each) do
    players = create_list(:player, 30)
    league = create(:league)
    players.each do |player|
      create(:player_league, player: player, league: league)
    end
  end

  describe '.find_redis_ranks' do
    it 'returns a paginated list of summoners' do
      ladder = Ladder.new('test')
      expect(ladder.find_redis_ranks(1).count).to eq 25
      expect(ladder.find_redis_ranks(2).count).to eq 5
    end
  end

  describe '.combine_players_with_rank' do
    it 'returns a list of players and ranks' do
      ladder = Ladder.new('test')
      first_player = ladder.combine_players_with_rank(Player.all).first
      expect(first_player.rank).to eq 1
    end
  end

  describe '#next_page?' do
    it 'returns true when next page exists' do
      expect(Ladder.next_page?(region: 'test', page: 1)).to eq true
    end

    it 'returns false when next page does not exist' do
      expect(Ladder.next_page?(region: 'test', page: 2)).to eq false
    end
  end

  describe '#prev_page?' do
    it 'returns true when prev page exists' do
      expect(Ladder.prev_page?(page: 2)).to eq true
    end

    it 'returns false when prev page does not exist' do
      expect(Ladder.prev_page?(page: 1)).to eq false
    end
  end
end
