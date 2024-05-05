class Admin::HomesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def top
    @spots = Spot.all
    @comments = Comment.all
    @kinds = Kind.all
  end
end
