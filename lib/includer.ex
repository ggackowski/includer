defmodule Includer do
  @moduledoc """
  Documentation for `Includer`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Includer.hello()
      :world

  """
  def loadSourceFromFile(fileName) do
    {:ok, f} = File.read(fileName)
    f
  end

  def reserved, do: ["if", "for", "while", "main", "switch"]

  def getFunctionsFromSource(text) do
    Regex.scan(~r/([A-Za-z_0-9]+)\(/, text)
    |> Enum.map(fn([_, b]) -> b end)
    |> Enum.filter(fn(x) -> !Enum.member?(reserved(), x) end)
  end

  def getIncludeFromMan(function) do
    case HTTPoison.get("https://manpages.debian.org/buster/manpages-dev/" <> function <> ".3.en.html") do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body |> Floki.find("pre") |> (fn([{_, _, [ {_, _, [a]} ]}| _]) -> a end).()

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def findIncludes(functions) do
    functions |> Enum.map(fn(function) -> getIncludeFromMan(function) end)
  end

  def saveToFile(includes, filename, oldsource) do
    File.write(filename, Enum.join(includes, "\n") <> "\n\n" <> oldsource)
  end

  def run(filename) do
    source = filename |> loadSourceFromFile
    includes = source |> getFunctionsFromSource |> findIncludes
    saveToFile(includes, filename, source)
  end
end
