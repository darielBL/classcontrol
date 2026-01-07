class DashboardController < ApplicationController
  before_action :authenticate_user! # Asegura que el usuario esté autenticado
  def index
    end
end
