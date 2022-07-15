require 'rails_helper'
require 'pry'

RSpec.describe SoundsController, :type => :controller do
  let!(:another_user) { User.create(email: 'example2@example.com', password: 'password2') }
  describe "GET /index" do
    context "when an user logged in" do
      let!(:user) { User.create(email: 'example@example.com',  password: 'password') }
      before { user_session }
      context "with some sounds" do
        let!(:sounds) do
          [
            FactoryBot.create(:sound, user_id: user.id),
            FactoryBot.create(:sound, user_id: another_user.id)
          ]
        end
        context "without filters" do
          it "returns all sounds" do
            get :index

            expect(response).to have_http_status(:ok)
            sounds_assertion(response.body, sounds)
          end
        end
        context "with filters" do
          context "with name filter" do
            let!(:name_filter) { sounds[0].name }
            it "returns the sounds filtered by name" do
              get :index, params: { name: name_filter }

              expect(response).to have_http_status(:ok)
              sound_assertion(response.body, sounds[0])
            end
          end
          context "with user filter" do
            let!(:user_filter) { sounds[0].user.id }
            it "returns the sounds filtered by name" do
              get :index, params: { user_id: user_filter }

              expect(response).to have_http_status(:ok)
              sound_assertion(response.body, sounds[0])
            end
          end
          context "with all filters" do
            let!(:name_filter) { sounds[0].name }
            let!(:user_filter) { sounds[0].user.id }
            it "returns the sounds filtered by name" do
              get :index, params: { name: name_filter,
                                    user_id: user_filter }

              expect(response).to have_http_status(:ok)
              sound_assertion(response.body, sounds[0])
            end
          end
        end
      end
      context "for no sounds found" do
        it "returns not found" do
          get :index

          expect(response).to have_http_status(:ok)
          expect(response.body).to eq([].to_json)
        end
      end
    end
    context "when an user logged in" do
      it "returns unauthorized" do
        get :index

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /show" do
    context "when an user logged in" do
      let!(:user) { User.create(email: 'example@example.com', password: 'password') }
      before { user_session }
      context "with a sound" do
        let!(:sound) { FactoryBot.create(:sound, user_id: user.id) }
        it "returns the sound" do
          get :show, params: { id: sound.id }

          expect(response).to have_http_status(:ok)
          expect(response.body).to eq(sound.to_json)
        end
      end
      context "for no sound found" do
        it "returns not found" do
          get :show, params: { id: 2 }

          expect(response.body).to eq({ errors: ['sound not found'] }.to_json)
          expect(response).to have_http_status(:not_found)
        end
      end
    end
    context "when an user logged in" do
      it "returns unauthorized" do
        get :show, params: { id: 2 }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /create" do
    context "when an user logged in" do
      let!(:user) { User.create(email: 'example@example.com', password: 'password') }
      before { user_session }
      it "creates a sound" do
        post :create, params: { name: 'sound-name',
                                duration: 10,
                                file_url: 'data/clap-808.wav' }

        expect(response).to have_http_status(:created)
        expect(Sound.first.name).to eq('sound-name')
        expect(Sound.first.duration).to eq(10)
        expect(Sound.first.file_url).to eq('data/clap-808.wav')
      end
    end
    context "when an user logged in" do
      it "returns unauthorized" do
        post :create, params: { name: 'sound-name',
                                duration: 10,
                                file_url: 'data/clap-808.wav' }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /update" do
    context "when an user logged in" do
      let!(:user) { User.create(email: 'example@example.com', password: 'password') }
      before { user_session }
      context "with a sound" do
        let!(:sound) { FactoryBot.create(:sound, user_id: user.id) }
        it "updates the sound" do
          put :update, params: { id: sound.id, name: 'new-name' }

          expect(response).to have_http_status(:ok)
          expect(sound.reload.name).to eq('new-name')
        end
      end
      context "for no sound found" do
        it "returns not found" do
          put :update, params: { id: 2 }

          expect(response.body).to eq({ errors: ['sound not found'] }.to_json)
          expect(response).to have_http_status(:not_found)
        end
      end
    end
    context "when an user logged in" do
      it "returns unauthorized" do
        put :update, params: { id: 2 }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /destroy" do
    context "when an user logged in" do
      let!(:user) { User.create(email: 'example@example.com', password: 'password') }
      before { user_session }
      context "with a sound" do
        let!(:sound) { FactoryBot.create(:sound, user_id: user.id) }
        it "deletes the sound" do
          delete :destroy, params: { id: sound.id }

          expect(response).to have_http_status(:no_content)
          expect(Sound.count).to eq(0)
        end
      end
      context "for no sound found" do
        it "returns not found" do
          delete :destroy, params: { id: 2 }

          expect(response.body).to eq({ errors: ['sound not found'] }.to_json)
          expect(response).to have_http_status(:not_found)
        end
      end
    end
    context "when an user logged in" do
      it "returns unauthorized" do
        delete :destroy, params: { id: 2 }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  def sounds_assertion(parsed_response, sounds)
    expect(parsed_response).to eq(sounds_object(sounds).to_json)
  end

  def sound_assertion(parsed_response, sound)
    expect(parsed_response).to eq(sound_object(sound).to_json)
  end

  def sounds_object(sounds)
    sounds.map do |sound|
      { id: sound.id,
        name: sound.name,
        user: sound.user }
    end
  end

  def sound_object(sound)
    [{ id: sound.id,
      name: sound.name,
      user: sound.user }]
  end
end
