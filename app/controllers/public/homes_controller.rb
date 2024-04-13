class Public::HomesController < ApplicationController
  before_action :authenticate_user!

  def top
    @spots = Spot.all
  end
end
