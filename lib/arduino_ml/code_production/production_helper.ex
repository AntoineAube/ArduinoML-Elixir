defmodule ArduinoML.ProductionHelper do

  def comment(content) do
    "// " <> content <> "\n"
  end

  def indented(content, level) do
    String.duplicate("  ", level) <> content
  end

  def statement(content) do
    content <> ";\n"
  end
  
  def new_line, do: "\n"
end
