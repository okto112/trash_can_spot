class Public::HomesController < ApplicationController

  def top
  end

  def main
    @spots = Spot.all
  end
end
