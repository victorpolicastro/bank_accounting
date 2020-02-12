class AccountsController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_account, except: %i[create]

  # GET /accounts/:id
  def show
    render json: @account, status: :ok
  end

  # POST /accounts
  def create
    @account = Account.new(account_params)
    if @account.save
      render json: @account, status: :created
    else
      render json: { errors: @account.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /accounts/:id
  def destroy
    @account.destroy unless @account.balance.positive?
  end

  private

  def find_account
    @account = Account.find_by(id: params[:_id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'Account not found' }, status: :not_found
  end

  def account_params
    params.permit(
      :name, :email, :password, :password_confirmation
    )
  end
end
