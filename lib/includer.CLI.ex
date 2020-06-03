defmodule Includer.CLI do
  @moduledoc """
  ## SYNOPSIS:
    Includes missing header files to the top of the C source file by searching linux MAN.
  ## USAGE:
    $ includer filename
  """

  def main([]), do:
    IO.puts("Usage: includer filname")

  def main([file]), do:
    Includer.run(file)

end
