class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @account = Account.find_by(id: params[:id])

    if @account&.authenticate(params[:password])
      token = JsonWebToken.encode(account_id: @account.id)
      time = Time.now + 20.minutes.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     id: @account.id }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:id, :password)
  end
end
