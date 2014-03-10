require 'net/http'

class RiotApi
  BASE_URL = 'https://prod.api.pvp.net/api/lol'

  def initialize(region)
    @region = region
  end

  def by_name(name)
    escaped_name = CGI::escape(name)
    response = get("v1.3/summoner/by-name/#{escaped_name}")
    if !response.nil? && response.code == '200'
      player = JSON.parse(response.body)
      return player[name]
    else
      nil
    end
  end

  def league_for(summoner_id)
    response = get("v2.3/league/by-summoner/#{summoner_id}/entry")
    if !response.nil? && response.code == '200'
      league = JSON.parse(response.body)
      return league.first
    else
      nil
    end
  end

  private

  def get(resource)
    begin
      uri = URI(build_url(resource))
      return Net::HTTP.get_response(uri)
    rescue StandardError
      nil
    end
  end

  def build_url(resource)
    "#{BASE_URL}/#{@region}/#{resource}?api_key=#{ENV['RIOT_API']}"
  end

end
