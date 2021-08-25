defmodule NflRushing.Rushing do
  @moduledoc """
  Documentation for `Rushing`.
  """

  @attributes [
    "Player",
    "Team",
    "Pos",
    "Att",
    "Att/G",
    "Yds",
    "Avg",
    "Yds/G",
    "TD",
    "Lng",
    "1st",
    "1st%",
    "20+",
    "40+",
    "FUM"
  ]

  @json_path "lib/nfl_rushing/rushing.json"

  @doc """
  Returns a list of maps from json file.
  """
  def get_all do
    file = File.read!(@json_path)
    {:ok, json} = Jason.decode(file)
    json
  end

  def get_attributes do
    @attributes
  end

  @doc """
  Returns a list of maps filetered by player's name.
  """
  def get_players(name) do
    name = String.downcase(name)

    get_all()
    |> Enum.filter(fn x ->
      String.downcase(x["Player"])
      |> String.contains?(name)
    end)
  end

  @doc """
  Returns a list of maps sorted by attributes.
  """
  def sort_by(sort_by, order) do
    get_all()
    |> Enum.sort_by(&(&1[sort_by]), order)
  end

  @doc """
  Generates csv file from given json list
  """
  def to_csv(json) do
    json
    |> Enum.map(fn x ->
      Enum.map(@attributes, fn a -> x[a] end)
    end)
    |> List.insert_at(0, @attributes)
    |> CSV.encode
    |> Enum.map(&(&1))
    |> to_string
  end

end
