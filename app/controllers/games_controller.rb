class GamesController < ApplicationController

  def create
    p params
    @figures_count = params[:figures_count]
    render json: {status: :ok, }
  end

  def show
    p params
    @figures_count = params[:figures_count]
    render json: {
      status: :ok,
      figure: rand(@figures_count)
    }
  end

  def update
    p params
    @figures_count = params[:figures_count]
    render json: {status: :ok}
  end

  def destroy
    p params
    @figures_count = params[:figures_count]
    render json: {status: :ok}
  end

end
