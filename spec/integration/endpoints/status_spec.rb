require 'spec_helper'
require 'rack/test'
require 'lab_manager/app'

describe 'Status' do
  include Rack::Test::Methods

  def app
    LabManager::App.new
  end

  describe 'GET /status/v_sphere' do
    before(:each) do
      allow(::Provider::VSphereConfig).to receive_message_chain(:scheduler, :max_vm) { 3 }

      create(:compute, provider_name: 'v_sphere', name: 'one').update_column(:state, 'errored')
      create(:compute, provider_name: 'v_sphere', name: 'two').update_column(:state, 'errored')

      create(:compute, provider_name: 'v_sphere', name: 'three').update_column(:state, 'created')
      create(:compute, provider_name: 'v_sphere', name: 'four').update_column(:state, 'created')
      create(:compute, provider_name: 'v_sphere', name: 'five').update_column(:state, 'created')

      create(:compute, provider_name: 'v_sphere', name: 'six').update_column(:state, 'running')

      create(:compute, provider_name: 'v_sphere', name: 'seven').update_column(:state, 'queued')
      create(:compute, provider_name: 'v_sphere', name: 'eight').update_column(:state, 'queued')
    end

    def perform_request
      get '/status/v_sphere'
      expect(last_response.status).to eq 200
      MultiJson.load(last_response.body)
    end

    it 'reads max_vm machines from vsphere configuration' do
      expect(::Provider::VSphereConfig).to receive_message_chain(:scheduler, :max_vm) { 3 }

      response_json = perform_request

      expect(response_json['max_running_machines']).to eq 3
    end

    it 'returns errored machines count' do
      response_json = perform_request

      expect(response_json['errored_machines']).to eq 2
    end

    it 'returns running machines count' do
      response_json = perform_request

      expect(response_json['running_machines']).to eq 1
    end

    it 'returns created machines count' do
      response_json = perform_request

      expect(response_json['created_machines']).to eq 3
    end

    it 'returns queued machines count' do
      response_json = perform_request

      expect(response_json['queued_machines']).to eq 2
    end
  end
end
