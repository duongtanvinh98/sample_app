class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      login_sucess user
    else
      flash.now[:danger] = t ".login_fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def login_sucess user
    if user.activated?
      log_in user
      if params[:session][:remember_me] == Settings.app.session.one
        remember user
      else
        forget user
      end
      redirect_back_or user
    else
      flash[:warning] = t ".account_not_activated"
      redirect_to root_path
    end
  end
end
