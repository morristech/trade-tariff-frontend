class HeadingsController < ApplicationController
  def show
    @heading = HeadingPresenter.new(Heading.find(params[:id], query_params), params[:country])
    @commodities = HeadingCommodityPresenter.new(@heading.commodities)
  end
end
