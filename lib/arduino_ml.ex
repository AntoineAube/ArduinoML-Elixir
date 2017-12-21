defmodule ArduinoML do
  @moduledoc """
  Contains the definition of the DSL API.
  """

  use Agent

  alias ArduinoML.Application, as: Application
  alias ArduinoML.Brick, as: Brick
  alias ArduinoML.Action, as: Action
  alias ArduinoML.Assertion, as: Assertion
  alias ArduinoML.State, as: State
  alias ArduinoML.Transition, as: Transition
  alias ArduinoML.CodeProducer, as: CodeProducer
  
  def application(name) do
    Agent.start_link(fn -> %Application{name: name} end, name: __MODULE__)
  end

  def sensor([{label, pin}]) do
    sensor = %Brick{label: label, pin: pin}

    Agent.update(__MODULE__, fn app -> Application.with_sensor(app, sensor) end)
  end

  def actuator([{label, pin}]) do
    actuator = %Brick{label: label, pin: pin}

    Agent.update(__MODULE__, fn app -> Application.with_actuator(app, actuator) end)
  end

  def state(label, on_entry: action = %Action{}) do
    state(label, on_entry: [action])
  end

  def state(label, on_entry: actions) when is_list(actions) do
    state = %State{label: label, actions: actions}

    Agent.update(__MODULE__, fn app -> Application.with_state(app, state) end)
  end

  def initial(label) do
    Agent.update(__MODULE__, fn app -> Application.with_initial(app, label) end)
  end

  def a ~> b when is_atom(a) and is_atom(b), do: %Action{actuator_label: a, signal: b}

  def a <~> b when is_atom(a) and is_atom(b), do: %Assertion{sensor_label: a, signal: b}

  def is_high?(label), do: label <~> :high

  def is_low?(label), do: label <~> :low
  
  def transition(from: from, to: to, when: condition = %Assertion{}) do
    transition(from: from, to: to, when: [condition])
  end

  def transition(from: from, to: to, when: conditions) when is_list(conditions) do
    transition = %Transition{from: from, to: to, on: conditions}

    Agent.update(__MODULE__, fn app -> Application.with_transition(app, transition) end)
  end

  def validate! do
    get_application
    |> validate_application
  end

  def to_code! do
    case validate! do
      :ok -> get_application |> CodeProducer.to_code
      :error -> "// The structure presents defects. The code cannot be generated."
    end
  end
  
  def finished! do
    to_code!
    |> IO.puts
  end

  defp get_application do
    Agent.get(__MODULE__, fn app -> app end)
  end

  defp validate_application(app) do
    # TODO Implement the validation.
    :ok
  end
  
end
