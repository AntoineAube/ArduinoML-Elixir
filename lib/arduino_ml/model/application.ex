defmodule ArduinoML.Application do

  alias ArduinoML.Brick, as: Brick
  alias ArduinoML.State, as: State
  alias ArduinoML.Transition, as: Transition
  
  defstruct name: nil,
    sensors: [],
    actuators: [],
    states: [],
    transitions: [],
    initial: nil

  def with_sensor(app, sensor = %Brick{}) do
    %ArduinoML.Application{app | sensors: [sensor | app.sensors]}
  end

  def with_actuator(app, actuator = %Brick{}) do
    %ArduinoML.Application{app | actuators: [actuator | app.actuators]}
  end

  def with_state(app, state = %State{}) do
    %ArduinoML.Application{app | states: [state | app.states]}
  end

  def with_transition(app, transition = %Transition{}) do
    %ArduinoML.Application{app | transitions: [transition | app.transitions]}
  end

  def with_initial(app, label) do
    %ArduinoML.Application{app | initial: label}
  end
    
  @doc """
  Returns the label of the initial state of the application.
  """
  def initial(app) when is_map(app) do
    app.initial || app.states[0].label
  end
  
end
