if Code.ensure_loaded?(Phoenix.Controller) do
  defmodule Beaker.MetricsApiController do
    use Beaker.Web, :controller

    def counters(conn, _params) do
      counters = Beaker.Counter.all
      conn
      |> json(counters)
    end

    def gauges(conn, _param) do
      gauges = Beaker.Gauge.all
      conn
      |> json(gauges)
    end

    def time_series(conn, _params) do
      time_series = Beaker.TimeSeries.all
      |> format_time_series
      conn
      |> json(time_series)
    end

    defp format_time_series(series) do
      Enum.reduce(series, %{}, fn {key, value}, acc ->
        Map.put(acc, key,  Enum.map(value, &tuples_to_map/1))
      end)
    end

    defp tuples_to_map({time, value}) do
      %{time: time, value: value}
    end

  end
end

