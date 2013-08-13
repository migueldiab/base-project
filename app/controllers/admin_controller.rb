class AdminController < ApplicationController
  
  before_filter :require_login
  layout "admin"
  
end
