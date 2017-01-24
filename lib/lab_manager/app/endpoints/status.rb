require 'lab_manager/app/endpoints/base'
require 'json'

module LabManager
  class App
    module Endpoints
      # class responsible for provider statuses
      class Status < Base
        get '/v_sphere' do
          provider_name = 'v_sphere'
          {
            max_running_machines: ::Provider::VSphereConfig.scheduler.max_vm,
            running_machines: ::Compute.where(provider_name: provider_name, state: 'running').count,
            errored_machines: ::Compute.where(provider_name: provider_name, state: 'errored').count,
            created_machines: ::Compute.where(provider_name: provider_name, state: 'created').count,
            queued_machines: ::Compute.where(provider_name: provider_name, state: 'queued').count
          }.to_json
        end
      end
    end
  end
end
