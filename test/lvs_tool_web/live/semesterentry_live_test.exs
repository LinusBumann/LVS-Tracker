defmodule LvsToolWeb.SemesterentryLiveTest do
  use LvsToolWeb.ConnCase

  import Phoenix.LiveViewTest
  import LvsTool.SemesterentrysFixtures

  @create_attrs %{name: "some name", status: "some status"}
  @update_attrs %{name: "some updated name", status: "some updated status"}
  @invalid_attrs %{name: nil, status: nil}

  defp create_semesterentry(_) do
    semesterentry = semesterentry_fixture()
    %{semesterentry: semesterentry}
  end

  describe "Index" do
    setup [:create_semesterentry]

    test "lists all semesterentrys", %{conn: conn, semesterentry: semesterentry} do
      {:ok, _index_live, html} = live(conn, ~p"/semesterentrys")

      assert html =~ "Listing Semesterentrys"
      assert html =~ semesterentry.name
    end

    test "saves new semesterentry", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/semesterentrys")

      assert index_live |> element("a", "New Semesterentry") |> render_click() =~
               "New Semesterentry"

      assert_patch(index_live, ~p"/semesterentrys/new")

      assert index_live
             |> form("#semesterentry-form", semesterentry: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#semesterentry-form", semesterentry: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/semesterentrys")

      html = render(index_live)
      assert html =~ "Semesterentry created successfully"
      assert html =~ "some name"
    end

    test "updates semesterentry in listing", %{conn: conn, semesterentry: semesterentry} do
      {:ok, index_live, _html} = live(conn, ~p"/semesterentrys")

      assert index_live |> element("#semesterentrys-#{semesterentry.id} a", "Edit") |> render_click() =~
               "Edit Semesterentry"

      assert_patch(index_live, ~p"/semesterentrys/#{semesterentry}/edit")

      assert index_live
             |> form("#semesterentry-form", semesterentry: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#semesterentry-form", semesterentry: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/semesterentrys")

      html = render(index_live)
      assert html =~ "Semesterentry updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes semesterentry in listing", %{conn: conn, semesterentry: semesterentry} do
      {:ok, index_live, _html} = live(conn, ~p"/semesterentrys")

      assert index_live |> element("#semesterentrys-#{semesterentry.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#semesterentrys-#{semesterentry.id}")
    end
  end

  describe "Show" do
    setup [:create_semesterentry]

    test "displays semesterentry", %{conn: conn, semesterentry: semesterentry} do
      {:ok, _show_live, html} = live(conn, ~p"/semesterentrys/#{semesterentry}")

      assert html =~ "Show Semesterentry"
      assert html =~ semesterentry.name
    end

    test "updates semesterentry within modal", %{conn: conn, semesterentry: semesterentry} do
      {:ok, show_live, _html} = live(conn, ~p"/semesterentrys/#{semesterentry}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Semesterentry"

      assert_patch(show_live, ~p"/semesterentrys/#{semesterentry}/show/edit")

      assert show_live
             |> form("#semesterentry-form", semesterentry: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#semesterentry-form", semesterentry: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/semesterentrys/#{semesterentry}")

      html = render(show_live)
      assert html =~ "Semesterentry updated successfully"
      assert html =~ "some updated name"
    end
  end
end
