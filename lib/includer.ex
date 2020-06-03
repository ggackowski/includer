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
    IO.puts(function <> "\n")
    case HTTPoison.get("https://manpages.debian.org/buster/manpages-dev/" <> function <> ".3.en.html") do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body |> Floki.parse_document! |> Floki.find("pre") |> (fn([{_, _, a}| _]) -> a end).() |> Enum.map(fn({_, _, [a]}) -> a end)

      {:ok, %HTTPoison.Response{status_code: 302}} ->

        case HTTPoison.get("https://manpages.debian.org/buster/manpages-dev/" <> function <> ".2.en.html") do

          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            body |> Floki.parse_document! |> Floki.find("pre") |> (fn([{_, _, a}| _]) -> a end).() |> Enum.map(fn({_, _, [a]}) -> a end)

          {:ok, %HTTPoison.Response{status_code: 302}} ->
            nil
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def findIncludes(functions) do
    functions |> Enum.map(fn(function) -> getIncludeFromMan(function) end) |> Enum.filter(fn(x) -> x != nil end) |> List.foldr([], &Enum.concat/2)

  end

  def saveToFile(includes, filename, oldsource) do
    File.write(filename, Enum.join(includes, "\n") <> "\n" <> oldsource)
    :ok
  end

  def run(filename) do
    source = filename |> loadSourceFromFile
    alreadyIncluded = Regex.scan(~r/#include[ ]*<[A-Za-z\/\.]+>/, source) |> Enum.map(fn([a]) -> a end)
    includes = source |> getFunctionsFromSource |> findIncludes
    includes = includes -- alreadyIncluded
    includes = includes |> Enum.uniq()
    if includes != [], do: saveToFile(includes, filename, source)
    :ok
  end
end
