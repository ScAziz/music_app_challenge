require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "POST /albums" do 
    it "creates a new album" do
      response = post('/albums', title: 'Voyage', release_year: '2022', artist_id: '2')
      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')
      expect(response.body).to include('Voyage')
    end

    context "GET /albums" do
      it "returns the list of albums with links to each" do
        response = get('/albums')

        expect(response.status).to eq(200)
        expect(response.body).to include('title: <a href="/albums/2"> Surfer Rosa </a>')
      end 
    end

    context "GET /albums/:id" do 
      it "returns info about album 1" do 
        response = get('/albums/1')

        # expect(response.status).to eq(200)
        expect(response.body).to include('Doolittle') 
      end
    end

    context "GET /artists/:id" do 
      it "returns  page with details of a single artist" do 
        response = get('/artists/1')

        expect(response.status).to eq(200)
        expect(response.body).to include('Pixies')
      end 
    end 

    context "GET /artists" do
      it "returns the list of artists with links to each" do
        response = get('/artists')

        expect(response.status).to eq(200)
        expect(response.body).to include('name: <a href="/artists/1"> Pixies </a>')
      end 
    end

    context "POST /artists" do
      it "returns 200 ok" do 
        response = post('/artists', name: 'Wild Nothing', genre: 'Indie')

        expect(response.status).to eq(200)
        expect(response.body).to eq('')
      end

      it "adds a new artist to the table" do
        response = get('/artists')
        expect(response.body).to include("Wild Nothing")
      end 
    end
 

    context "GET /albums/new" do 
      it "returns the form page" do 
        response = get('/albums/new')

        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>Add an album</h1>')
        expect(response.body).to include('<form action="/albums" method="POST">')
      end 
    end 
    
  end
end
