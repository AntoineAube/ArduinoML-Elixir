use ArduinoML

application "Transfer analogical signal"

sensor button: 9
sensor temperature: 10, type: :analogic
actuator led: 12

state :off, on_entry: :led ~> :low
state :on, on_entry: :led <~ :temperature

transition from: :off, to: :on, when: is_high?(:button)
transition from: :on, to: :off, when: is_low?(:button)

finished! :show_me
