defmodule ArduinoML.Application do

  defstruct name: "default-application",
    sensors: [],
    actuators: [],
    states: [],
    transitions: [],
    initial: nil

  def initial(app) when is_map(app) do
    app.initial || app.states[0].label
  end
  
end
