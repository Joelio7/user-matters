require 'rails_helper'

RSpec.describe Api::MattersController, type: :request do
  let(:user) { create(:user) }
  let(:matter) { create(:matter, user: user) }
  let(:headers) { auth_headers(user) }

  def auth_headers(user)
    token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
    { 'Authorization' => "Bearer #{token}" }
  end

  describe 'GET /api/matters' do
    it 'returns a success response' do
      get '/api/matters', headers: headers
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'returns matters as JSON' do
      matter # create the matter
      get '/api/matters', headers: headers

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
    end

    it 'requires authentication' do
      get '/api/matters'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /api/matters/:id' do
    it 'returns a success response' do
      get "/api/matters/#{matter.id}", headers: headers
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'returns the matter as JSON' do
      get "/api/matters/#{matter.id}", headers: headers

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(matter.id)
      expect(json_response['title']).to eq(matter.title)
    end

    it 'returns 404 for non-existent matter' do
      get '/api/matters/999999', headers: headers
      expect(response).to have_http_status(:not_found)
    end

    it 'requires authentication' do
      get "/api/matters/#{matter.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /api/matters' do
    context 'with valid params' do
      let(:valid_attributes) do
        {
          title: 'Test Matter',
          description: 'Test Description',
          state: 'new',
          due_date: 1.week.from_now
        }
      end

      it 'creates a new Matter' do
        expect {
          post '/api/matters', params: valid_attributes, headers: headers
        }.to change(Matter, :count).by(1)
      end

      it 'returns the created matter' do
        post '/api/matters', params: valid_attributes, headers: headers

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('Test Matter')
        expect(json_response['state']).to eq('new')
      end

      it 'associates the matter with the current user' do
        post '/api/matters', params: valid_attributes, headers: headers

        created_matter = Matter.last
        expect(created_matter.user).to eq(user)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        {
          title: '',
          state: 'invalid_state'
        }
      end

      it 'returns unprocessable entity status' do
        post '/api/matters', params: invalid_attributes, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        post '/api/matters', params: invalid_attributes, headers: headers

        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Matter could not be created')
        expect(json_response['errors']).to be_an(Array)
      end

      it 'does not create a matter' do
        expect {
          post '/api/matters', params: invalid_attributes, headers: headers
        }.not_to change(Matter, :count)
      end
    end

    it 'requires authentication' do
      post '/api/matters', params: { title: 'Test' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PUT /api/matters/:id' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          title: 'Updated Matter Title',
          description: 'Updated Description'
        }
      end

      it 'updates the requested matter' do
        put "/api/matters/#{matter.id}", params: new_attributes, headers: headers
        matter.reload
        expect(matter.title).to eq('Updated Matter Title')
        expect(matter.description).to eq('Updated Description')
      end

      it 'returns the updated matter' do
        put "/api/matters/#{matter.id}", params: new_attributes, headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('Updated Matter Title')
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        { title: '' }
      end

      it 'returns unprocessable entity status' do
        put "/api/matters/#{matter.id}", params: invalid_attributes, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        put "/api/matters/#{matter.id}", params: invalid_attributes, headers: headers

        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Matter could not be updated')
        expect(json_response['errors']).to be_an(Array)
      end
    end

    it 'returns 404 for non-existent matter' do
      put '/api/matters/999999', params: { title: 'Updated' }, headers: headers
      expect(response).to have_http_status(:not_found)
    end

    it 'requires authentication' do
      put "/api/matters/#{matter.id}", params: { title: 'Updated' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE /api/matters/:id' do
    it 'destroys the requested matter' do
      matter # create the matter
      expect {
        delete "/api/matters/#{matter.id}", headers: headers
      }.to change(Matter, :count).by(-1)
    end

    it 'returns no content status' do
      delete "/api/matters/#{matter.id}", headers: headers
      expect(response).to have_http_status(:no_content)
      expect(response.body).to be_empty
    end

    it 'returns 404 for non-existent matter' do
      delete '/api/matters/999999', headers: headers
      expect(response).to have_http_status(:not_found)
    end

    it 'requires authentication' do
      delete "/api/matters/#{matter.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'authorization' do
    let(:other_user) { create(:user) }
    let(:other_user_matter) { create(:matter, user: other_user) }
    let(:other_user_headers) { auth_headers(other_user) }

    it 'does not allow users to access other users matters' do
      get "/api/matters/#{other_user_matter.id}", headers: headers
      expect(response).to have_http_status(:not_found)
    end

    it 'does not allow users to update other users matters' do
      put "/api/matters/#{other_user_matter.id}",
          params: { title: 'Hacked' },
          headers: headers
      expect(response).to have_http_status(:not_found)
    end

    it 'does not allow users to delete other users matters' do
      delete "/api/matters/#{other_user_matter.id}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
