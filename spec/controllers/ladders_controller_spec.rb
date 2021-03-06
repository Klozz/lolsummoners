require 'spec_helper'

describe LaddersController do
  describe 'GET show' do
    it 'should return 404 for an invalid region' do
      expect {
        get :show, region: 'fake', page: 1
      }.to raise_error(ActionController::RoutingError)
    end

    it 'should set page to 1 as default' do
      get :show, region: 'all'
      expect(controller.params[:page]).to eq 1
    end

    it 'should set page to 1 when less than 1' do
      get :show, region: 'all', page: 0
      expect(controller.params[:page]).to eq 1
    end

    it 'should downcase id' do
      get :show, region: 'ALL', page: 1
      expect(controller.params[:region]).to eq 'all'
    end
  end
end
