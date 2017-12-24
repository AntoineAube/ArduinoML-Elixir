defmodule ArduinoML.SignalTest do
  use ExUnit.Case
  doctest ArduinoML.Action

  test "Should not replace an integer" do
    assert ArduinoML.Signal.enhanced(2, %ArduinoML.Application{}) == 2
  end

  test "Should not replace LOW or HIGH" do
    assert ArduinoML.Signal.enhanced(:low, %ArduinoML.Application{}) == :low
    assert ArduinoML.Signal.enhanced(:high, %ArduinoML.Application{}) == :high
  end

  test "Should replace the labelled signal" do
    button = %ArduinoML.Brick{label: :button, pin: 1}
    application = %ArduinoML.Application{sensors: [button]}

    assert ArduinoML.Signal.enhanced(:button, application) == button
  end

  test "Should recognize a constant digital signal" do
    assert ArduinoML.Signal.digital?(:low, %ArduinoML.Application{})
    assert ArduinoML.Signal.digital?(:high, %ArduinoML.Application{})
    assert not ArduinoML.Signal.digital?(1, %ArduinoML.Application{})
  end

  test "Should recognize a variable digital signal" do
    application = %ArduinoML.Application{sensors: [%ArduinoML.Brick{label: :button, pin: 1}]}

    assert ArduinoML.Signal.digital?(:button, application)
    assert ArduinoML.Signal.digital?(%ArduinoML.Brick{label: :button, pin: 1}, application)
    assert not ArduinoML.Signal.digital?(:led, application)
  end
  
  test "Should recognize a constant analogic signal" do
    assert not ArduinoML.Signal.analogic?(:low, %ArduinoML.Application{})
    assert not ArduinoML.Signal.analogic?(:high, %ArduinoML.Application{})
    assert ArduinoML.Signal.analogic?(4, %ArduinoML.Application{})
  end

  test "Should recognize a variable analogic signal" do
    application = %ArduinoML.Application{sensors: [%ArduinoML.Brick{label: :temperature, pin: 1, type: :analogic}]}

    assert ArduinoML.Signal.analogic?(:temperature, application)
    assert ArduinoML.Signal.analogic?(%ArduinoML.Brick{label: :temperature, pin: 1, type: :analogic}, application)
    assert not ArduinoML.Signal.analogic?(:led, application)
  end
    
end

