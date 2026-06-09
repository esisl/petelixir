defmodule PetelixirWeb.DeviceLiveTest do
  use PetelixirWeb.ConnCase

  import Phoenix.LiveViewTest
  import Petelixir.DevicesFixtures

  @create_attrs %{name: "some name", status: "some status", device_type: "some device_type", last_seen: "2026-06-08T07:40:00Z", firmware_version: "some firmware_version"}
  @update_attrs %{name: "some updated name", status: "some updated status", device_type: "some updated device_type", last_seen: "2026-06-09T07:40:00Z", firmware_version: "some updated firmware_version"}
  @invalid_attrs %{name: nil, status: nil, device_type: nil, last_seen: nil, firmware_version: nil}

  defp create_device(_) do
    device = device_fixture()
    %{device: device}
  end

  describe "Index" do
    setup [:create_device]

    test "lists all devices", %{conn: conn, device: device} do
      {:ok, _index_live, html} = live(conn, ~p"/devices")

      assert html =~ "Listing Devices"
      assert html =~ device.name
    end

    test "saves new device", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/devices")

      assert index_live |> element("a", "New Device") |> render_click() =~
               "New Device"

      assert_patch(index_live, ~p"/devices/new")

      assert index_live
             |> form("#device-form", device: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#device-form", device: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/devices")

      html = render(index_live)
      assert html =~ "Device created successfully"
      assert html =~ "some name"
    end

    test "updates device in listing", %{conn: conn, device: device} do
      {:ok, index_live, _html} = live(conn, ~p"/devices")

      assert index_live |> element("#devices-#{device.id} a", "Edit") |> render_click() =~
               "Edit Device"

      assert_patch(index_live, ~p"/devices/#{device}/edit")

      assert index_live
             |> form("#device-form", device: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#device-form", device: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/devices")

      html = render(index_live)
      assert html =~ "Device updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes device in listing", %{conn: conn, device: device} do
      {:ok, index_live, _html} = live(conn, ~p"/devices")

      assert index_live |> element("#devices-#{device.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#devices-#{device.id}")
    end
  end

  describe "Show" do
    setup [:create_device]

    test "displays device", %{conn: conn, device: device} do
      {:ok, _show_live, html} = live(conn, ~p"/devices/#{device}")

      assert html =~ "Show Device"
      assert html =~ device.name
    end

    test "updates device within modal", %{conn: conn, device: device} do
      {:ok, show_live, _html} = live(conn, ~p"/devices/#{device}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Device"

      assert_patch(show_live, ~p"/devices/#{device}/show/edit")

      assert show_live
             |> form("#device-form", device: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#device-form", device: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/devices/#{device}")

      html = render(show_live)
      assert html =~ "Device updated successfully"
      assert html =~ "some updated name"
    end
  end
end
