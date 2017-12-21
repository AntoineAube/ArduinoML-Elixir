# ArduinoML implementation in Elixir

This directory is one quick implementation of ArduinoML in Elixir

## Requirements
- An Elixir installation on your system.
- Compile the project with ```mix compile```.
- Run it on a file with ```mix run FILE_PATH``` (example: ```mix run samples/switch.exs```).

## Syntax example

This example can be found in [samples/switch.exs](./samples/switch.exs).

```elixir
import ArduinoML

application("Switch!")
|> sensors(button: 9)
|> actuators(led: 12)

|> state(named: :on, execute: :led ~> :high)
|> state(named: :off, execute: :led ~> :low)
|> initial(:off)

|> transition(from: :on, to: :off, on: is_high?(:button))
|> transition(from: :off, to: :on, on: is_high?(:button))

|> to_code
|> IO.puts
```

This is transpiled into... that creepy code:

```c
// generated by ArduinoML #Elixir.

// Bricks <~> Pins.
int BUTTON = 9;
int LED = 12;

// Setup the inputs and outputs
void setup() {
  pinMode(BUTTON, INPUT);

  pinMode(LED, OUTPUT);
}

// Static setup code.
int state = LOW;
int prev = HIGH;
long time = 0;
long debounce = 200;

// States declarations.
void state_off() {
  digitalWrite(LED, LOW);

  boolean guard = millis() - time > debounce;

  if (digitalRead(BUTTON) == HIGH && guard) {
    time = millis();
    state_on();
  } else {
    state_off();
  }
}

void state_on() {
  digitalWrite(LED, HIGH);

  boolean guard = millis() - time > debounce;

  if (digitalRead(BUTTON) == HIGH && guard) {
    time = millis();
    state_off();
  } else {
    state_on();
  }
}

// This function specify the first state.
void loop() {
  state_off();
}
```

## TODO List

- Check the parameters validity.
- Add documentation.
- Implement more examples.
