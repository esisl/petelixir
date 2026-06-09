defmodule Petelixir.Redis do
  @moduledoc """
  Модуль для работы с Redis (NoSQL хранилище).
  Используется для кэширования последнего состояния устройств.
  """

  use GenServer

  # Публичный API
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def set_last_telemetry(device_id, telemetry) do
    GenServer.call(__MODULE__, {:set, device_id, telemetry})
  end

  def get_last_telemetry(device_id) do
    GenServer.call(__MODULE__, {:get, device_id})
  end

  # GenServer callbacks
  @impl true
  def init(_opts) do
    # Подключаемся к Redis
    {:ok, conn} = Redix.start_link("redis://localhost:6379")
    {:ok, %{conn: conn}}
  end

  @impl true
  def handle_call({:set, device_id, telemetry}, _from, %{conn: conn} = state) do
    key = "device:#{device_id}:telemetry"
    # Сохраняем JSON в Redis с TTL 1 час
    {:ok, _} = Redix.command(conn, ["SET", key, Jason.encode!(telemetry), "EX", "3600"])
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:get, device_id}, _from, %{conn: conn} = state) do
    key = "device:#{device_id}:telemetry"
    {:ok, result} = Redix.command(conn, ["GET", key])
    
    telemetry = case result do
      nil -> nil
      json -> Jason.decode!(json)
    end
    
    {:reply, telemetry, state}
  end
end