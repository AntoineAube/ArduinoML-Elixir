defmodule ArduinoML.Transpiler do

  alias ArduinoML.Application, as: Application
  
  def to_code(application) when is_map(application) do
    application.name
  end
  
end
