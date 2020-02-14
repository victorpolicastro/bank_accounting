require 'rails_helper'

RSpec.describe 'Accounts', type: :request do
  context 'creating a new account' do
    before do
      post '/accounts',
           params: {
             name: Faker::Name.name,
             email: Faker::Internet.email,
             password: Faker::Alphanumeric.alphanumeric(number: 10)
           }
    end

    it 'returns status code 201' do
      expect(response).to have_http_status(:created)
    end
  end

  context 'when user tries to create an incomplete account' do
    before do
      post '/accounts',
           params: {
             name: nil,
             email: Faker::Internet.email,
             password: Faker::Alphanumeric.alphanumeric(number: 10)
           }
    end

    it 'returns status code 422' do
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'when user login' do
    let(:password) { Faker::Alphanumeric.alphanumeric(number: 10) }
    let!(:account) { create :account, password: password }

    before { post '/auth/login', params: { id: account.id, password: password } }

    it 'returns status code 200 and a JWT' do
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(parsed_response['token']).not_to(be(nil))
      expect(parsed_response['exp']).not_to(be(nil))
      expect(parsed_response['id']).not_to(be(nil))
    end
  end

  context 'when user tries to login with incorrect password' do
    let(:password) { Faker::Alphanumeric.alphanumeric(number: 10) }
    let!(:account) { create :account, password: password }

    before do
      post '/auth/login',
           params: {
             id: account.id,
             password: Faker::Alphanumeric.alphanumeric(number: 10)
           }
    end

    it 'returns status code 401 and a JWT' do
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when a logged user send request to see current_balance' do
    let!(:account) { create :account, :with_balance }
    let(:jwt) { JsonWebToken.encode(account_id: account.id) }

    before { get '/account', headers: { authorization: "Beared #{jwt}" } }

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'when a logged user with balance transacts money' do
    let!(:account) { create :account, :with_balance }
    let!(:destination_account) { create :account }
    let(:jwt) { JsonWebToken.encode(account_id: account.id) }

    before do
      get '/account',
          headers: {
            authorization: "Beared #{jwt}"
          },
          params: {
            destination_account_id: destination_account.id,
            amount: Faker::Number.number(digits: 2)
          }
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end
end
