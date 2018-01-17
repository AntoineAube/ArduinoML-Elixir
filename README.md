# ArduinoML implementation in Elixir

This directory is one quick implementation of ArduinoML in Elixir

## Requirements
- An Elixir installation on your system.
- *optional:* Compile the project with ```mix compile```.
- *optional:* Execute the tests with ```mix test```.
- Run it on a file with ```mix run FILE_PATH``` (example: ```mix run samples/dual_check_alarm.exs```).

## Project structure

- The *abstract syntax* is in the [lib/arduino_ml/model](./lib/arduino_ml/model) folder. It is made of structures, so there is no inheritance nor references.
- The *concrete syntax* is in the file [lib/arduino_ml.ex](./lib/arduino_ml.ex).
- The *validation* is in the file [lib/arduino_ml/model_validation/model_validator.ex](./lib/arduino_ml/model_validation/model_validator.ex).
- The *code generation* is in the folder [lib/arduino_ml/code_production](./lib/arduino_ml/code_production).

## Syntax example

This example can be found in [samples/dual_check_alarm.exs](./samples/dual_check_alarm.exs).

```elixir
use ArduinoML

application "Dual-check alarm"

sensor button1: 9
sensor button2: 10
actuator buzzer: 12

state :released, on_entry: :buzzer ~> :low
state :pushed, on_entry: :buzzer ~> :high

transition from: :released, to: :pushed, when: is_high?(:button1) and is_high?(:button2)
transition from: :pushed, to: :released, when: is_low?(:button1)
transition from: :pushed, to: :released, when: is_low?(:button2)

finished! save_into: "output.c"
```

This is transpiled into... that creepy code (& saved into ```output.c```):

```c
// generated by ArduinoML #Elixir.

// Bricks <~> Pins.
int BUTTON2 = 10;
int BUTTON1 = 9;
int BUZZER = 12;

// Setup the inputs and outputs.
void setup() {
  pinMode(BUTTON2, INPUT);
  pinMode(BUTTON1, INPUT);

  pinMode(BUZZER, OUTPUT);
}

// Static setup code.
int currentState = 1;

// States declarations.
void state_pushed() {
  digitalWrite(BUZZER, HIGH);

  if (digitalRead(BUTTON2) == LOW) {
    currentState = 1;
  } else if (digitalRead(BUTTON1) == LOW) {
    currentState = 1;
  }
}

void state_released() {
  digitalWrite(BUZZER, LOW);

  if (digitalRead(BUTTON1) == HIGH && digitalRead(BUTTON2) == HIGH) {
    currentState = 0;
  }
}

// This function specifies the first state.
void loop() {
  if (currentState == 0) {
    state_pushed();
  } else if (currentState == 1) {
    state_released();
  } else {
    /* Not supposed to arrive here. */
  }
}

```

## TODO List

- Implement more examples.
