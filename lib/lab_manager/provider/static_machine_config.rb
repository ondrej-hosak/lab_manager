require 'settingslogic'

module Provider
  # Configuration of the StaticMachine provider
  class StaticMachineConfig < Settingslogic
    source "#{LabManager.root}/config/provider_static_machine.yml"
    namespace LabManager.env
  end
end
