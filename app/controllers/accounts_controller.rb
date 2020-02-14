class AccountsController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_account, except: %i[create]

  # GET /accounts
  def show
    data = AccountPresenter.new(@current_account).call

    render json: { data: data }
  end

  # POST /accounts
  def create
    @account = Account.new(account_params)
    if @account.save
      render json: @account, status: :created
    else
      render(json: { errors: @account.errors.full_messages },
             status: :unprocessable_entity)
    end
  end

  # POST /accounts/
  def transactions
    destination_account_id = params[:destination_account_id]
    amount = params[:amount]

    response =
      CreateTransactionService.new(
        @current_account,
        destination_account_id,
        amount
      ).call

    render(json: { errors: response.messages }, status: :bad_request) and return unless response.success?
    render(json: { messages: response.messages }, status: :ok)
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
