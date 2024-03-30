class Admin::SpotsController < ApplicationController
  before_action :authenticate_admin!
end
