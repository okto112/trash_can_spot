class Public::HomesController < ApplicationController
  before_action :authenticate_user!

  def top
  end

  def main
    @spots = Spot.all
  end
end
