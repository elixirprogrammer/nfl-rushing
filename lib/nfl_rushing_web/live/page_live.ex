defmodule NflRushingWeb.PageLive do
  use NflRushingWeb, :live_view

  alias NflRushing.Rushing

  @impl true
  def mount(_params, _session, socket) do
    rushing_json = Rushing.get_all
    table_attributes = Rushing.get_attributes

    {:ok,
      socket
      |> assign(table_attributes: table_attributes)
      |> assign(rushing_json: rushing_json)}
  end


  @impl true
  def handle_event("filter-player", %{"player" => player}, socket) do
    players = Rushing.get_players(player)
    params = [player: player]

    {:noreply,
      socket
      |> assign(download_path: Routes.page_path(socket, :csv, params))
      |> assign(rushing_json: players)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    sort_by = params["sort_by"]
    sort_order = (params["order"] || "asc") |> String.to_atom()
    rushing_json = Rushing.sort_by(sort_by, sort_order)
    params = [sort_by: sort_by, order: sort_order]

    {:noreply,
      socket
      |> assign(sort_order: sort_order)
      |> assign(sort_by: sort_by)
      |> assign(download_path: Routes.page_path(socket, :csv, params))
      |> assign(rushing_json: rushing_json)}
  end

  defp sort_link(socket, attribute, sort_by, sort_order) do
    text =
      if sort_by == attribute do
        attribute <> emoji(sort_order)
      else
        attribute
      end

    live_patch(text,
      to: Routes.page_path(
        socket,
        :index,
        sort_by: attribute,
        order: toggle_sort_order(sort_order)
      )
    )
  end

  defp toggle_sort_order(:asc), do: :desc
  defp toggle_sort_order(:desc), do: :asc

  defp emoji(:asc), do: "👇"
  defp emoji(:desc), do: "👆"

end
