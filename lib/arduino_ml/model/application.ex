defmodule ArduinoML.Application do

  defstruct name: "default-application",
    sensors: [],
    actuators: [],
    states: %{},
    transitions: [],
    initial: nil
  
end
