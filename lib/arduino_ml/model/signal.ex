defmodule ArduinoML.Signal do

  def enhanced(signal, _) when is_integer(signal) or signal in [:low, :high], do: signal
  def enhanced(signal, application) do
    ArduinoML.Brick.enhanced(signal, application.sensors)
  end
  
  def digital?(:low, _), do: true
  def digital?(:high, _), do: true
  def digital?(%{type: type}, _), do: type == :digital
  def digital?(signal, application) when (is_atom(signal) or is_binary(signal)) and not is_nil(signal) do
    signal
    |> ArduinoML.Signal.enhanced(application)
    |> digital?(application)
  end
  def digital?(_, _), do: false

  def analogic?(:low, _), do: false
  def analogic?(:high, _), do: false
  def analogic?(nil, _), do: false
  def analogic?(signal, application) when (is_atom(signal) or is_binary(signal)) and not is_nil(signal) do
    signal
    |> ArduinoML.Signal.enhanced(application)
    |> analogic?(application)
  end
  def analogic?(signal, application), do: not digital?(signal, application)

end
