defmodule PetelixirWeb.DeviceControllerTest do
  use PetelixirWeb.ConnCase

  import Petelixir.DevicesFixtures

  alias Petelixir.Devices.Device

  @create_attrs %{
    name: "some name",
    status: "some status",
    device_type: "some device_type",
    last_seen: ~U[2026-06-08 07:54:00Z],
    firmware_version: "some firmware_version"
  }
  @update_attrs %{
    name: "some updated name",
    status: "some updated status",
    device_type: "some updated device_type",
    last_seen: ~U[2026-06-09 07:54:00Z],
    firmware_version: "some updated firmware_version"
  }
  @invalid_attrs %{name: nil, status: nil, device_type: nil, last_seen: nil, firmware_version: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all devices", %{conn: conn} do
      conn = get(conn, ~p"/api/devices")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create device" do
    test "renders device when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/devices", device: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/devices/#{id}")

      assert %{
               "id" => ^id,
               "device_type" => "some device_type",
               "firmware_version" => "some firmware_version",
               "last_seen" => "2026-06-08T07:54:00Z",
               "name" => "some name",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/devices", device: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update device" do
    setup [:create_device]

    test "renders device when data is valid", %{conn: conn, device: %Device{id: id} = device} do
      conn = put(conn, ~p"/api/devices/#{device}", device: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/devices/#{id}")

      assert %{
               "id" => ^id,
               "device_type" => "some updated device_type",
               "firmware_version" => "some updated firmware_version",
               "last_seen" => "2026-06-09T07:54:00Z",
               "name" => "some updated name",
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, device: device} do
      conn = put(conn, ~p"/api/devices/#{device}", device: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete device" do
    setup [:create_device]

    test "deletes chosen device", %{conn: conn, device: device} do
      conn = delete(conn, ~p"/api/devices/#{device}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/devices/#{device}")
      end
    end
  end

  defp create_device(_) do
    device = device_fixture()
    %{device: device}
  end
end
