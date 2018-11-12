class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  require 'will_paginate/array'

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def ensure_admin
    return redirect_to(root_path), notice: 'Your Unauthorized Access Attempt has been logged.' unless current_user.is_admin
    true
  end
end
