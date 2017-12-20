defmodule ArduinoML do

  alias ArduinoML.Application, as: Application
  alias ArduinoML.Brick, as: Brick
  alias ArduinoML.Action, as: Action
  alias ArduinoML.Assertion, as: Assertion
  alias ArduinoML.State, as: State
  alias ArduinoML.Transition, as: Transition
  
  def application(), do: %Application{}
  def application(name), do: %Application{name: name}

  def sensors(app, sensors) when is_list(sensors) do
    %Application{app | sensors: to_bricks(sensors)}
  end

  def actuators(app, actuators) when is_list(actuators) do
    %Application{app | actuators: to_bricks(actuators)}
  end

  defp to_bricks(tokens) when is_list(tokens) do
    Enum.map(tokens, fn {label, pin} -> %Brick{label: label, pin: pin} end)
  end
  
  def state(app, [named: label]) do
    state(app, [named: label, execute: []])
  end
  
  def state(app, [named: label, execute: action]) when is_map(action) do
    state(app, [named: label, execute: [action]])
  end

  def state(app, [named: label, execute: actions]) when is_list(actions) do
    state = %State{label: label, actions: actions}
    
    %Application{app | states: [state | app.states]}
  end

  def initial(app, label) do
    %Application{app | initial: label}
  end

  def transition(app, [from: from, to: to, on: assertion]) when is_map(assertion) do
    transition(app, [from: from, to: to, on: [assertion]])
  end

  def transition(app, [from: from, to: to, on: assertions]) when is_list(assertions) do
    transition = %Transition{from: from, to: to, on: assertions}

    %Application{app | transitions: [transition | app.transitions]}
  end
  
  def a ~> b, do: %Action{label: a, signal: b}
  
  def a <~> b, do: %Assertion{label: a, signal: b}

  def is_high?(label), do: label <~> :high
  def is_low?(label), do: label <~> :low

  def to_code(app) do
    ArduinoML.CodeProducer.to_code(app)
  end
  
end
