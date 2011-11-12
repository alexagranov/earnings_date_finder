class EarningsController < ApplicationController

  def index
    @earnings = []
  end

  def new
    @earning = Earning.new
  end

end
