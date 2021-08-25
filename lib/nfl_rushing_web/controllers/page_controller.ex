defmodule NflRushingWeb.PageController do
  use NflRushingWeb, :controller

  alias NflRushing.Rushing

  def csv(conn, params) do
    send_download(conn, {:binary, csv_content(params)}, filename: "rushing.csv")
  end

  defp csv_content(params) do
    get_rushing_json(params) |> Rushing.to_csv
  end

  defp get_rushing_json(params) do
    sort_by = params["sort_by"]
    player? = Map.has_key?(params, "player")

    cond do
      sort_by == "" ->
        Rushing.get_all
      player? ->
        Rushing.get_players(params["player"])
      true ->
        order = params["order"] |> String.to_atom()
        Rushing.sort_by(sort_by, order)
    end
  end

end
