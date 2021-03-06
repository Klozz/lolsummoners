class SearchesController < ApplicationController
  before_action :prepare_params, :check_params, :find_player, except: [:trigger]

  def show
    if @player
      redirect_to player_path(region: @player.region, summoner_id: @player.summoner_id)
    else
      @region = params[:region]
      @name = params[:name]
    end
  end

  def trigger
    return unless params[:name] && params[:region]

    SearchJob.perform_later(params[:region], params[:name])

    render nothing: true
  end

  private

  def find_player
    @player = Player.find_by(internal_name: params[:name], region: params[:region])
  end

  def check_params
    if params[:region].blank? || params[:name].blank?
      flash[:error] = 'You need to specify a name to search for.'
      redirect_to root_path
    end
  end

  def prepare_params
    params[:name] = params[:name].to_s.downcase.gsub(/\s+/, '')
  end
end
