class SearchesController < ApplicationController
  before_action :prepare_params
  before_action :rate_limited?

  def show
    unless params[:name].present? && params[:region].present?
      flash[:error] = 'You need to specify a name to search for.'
      redirect_to root_path
    end
    player = Player.name_and_region(params[:name], params[:region]).first
    if player
      redirect_to player_path(region: player.region, summoner_id: player.summoner_id)
    else
      SearchWorker.queue(region: params[:region], id: params[:name], by: :name, caller: :search)
      @region = params[:region]
      @name = params[:name]
    end
  end

  private

  def prepare_params
    params[:name] = params[:name].downcase.gsub(/\s+/, '')
  end

  def rate_limited?
    ip = request.remote_ip || 'unknown_ip'
    key_name = "#{ip}_#{Time.now.to_i}"
    if RateLimit.limited?(key_name)
      render status: 429, text: 'Too much'
    else
      RateLimit.set(key_name, 1)
    end
  end
end
