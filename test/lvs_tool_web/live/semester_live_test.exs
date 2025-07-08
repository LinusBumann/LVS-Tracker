defmodule LvsToolWeb.SemesterLiveTest do
  use LvsToolWeb.ConnCase

  import Phoenix.LiveViewTest
  import LvsTool.LehrdeputatFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_semester(_) do
    semester = semester_fixture()
    %{semester: semester}
  end

  describe "Index" do
    setup [:create_semester]

    test "lists all semesters", %{conn: conn, semester: semester} do
      {:ok, _index_live, html} = live(conn, ~p"/semesters")

      assert html =~ "Listing Semesters"
      assert html =~ semester.name
    end

    test "saves new semester", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/semesters")

      assert index_live |> element("a", "New Semester") |> render_click() =~
               "New Semester"

      assert_patch(index_live, ~p"/semesters/new")

      assert index_live
             |> form("#semester-form", semester: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#semester-form", semester: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/semesters")

      html = render(index_live)
      assert html =~ "Semester created successfully"
      assert html =~ "some name"
    end

    test "updates semester in listing", %{conn: conn, semester: semester} do
      {:ok, index_live, _html} = live(conn, ~p"/semesters")

      assert index_live |> element("#semesters-#{semester.id} a", "Edit") |> render_click() =~
               "Edit Semester"

      assert_patch(index_live, ~p"/semesters/#{semester}/edit")

      assert index_live
             |> form("#semester-form", semester: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#semester-form", semester: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/semesters")

      html = render(index_live)
      assert html =~ "Semester updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes semester in listing", %{conn: conn, semester: semester} do
      {:ok, index_live, _html} = live(conn, ~p"/semesters")

      assert index_live |> element("#semesters-#{semester.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#semesters-#{semester.id}")
    end
  end

  describe "Show" do
    setup [:create_semester]

    test "displays semester", %{conn: conn, semester: semester} do
      {:ok, _show_live, html} = live(conn, ~p"/semesters/#{semester}")

      assert html =~ "Show Semester"
      assert html =~ semester.name
    end

    test "updates semester within modal", %{conn: conn, semester: semester} do
      {:ok, show_live, _html} = live(conn, ~p"/semesters/#{semester}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Semester"

      assert_patch(show_live, ~p"/semesters/#{semester}/show/edit")

      assert show_live
             |> form("#semester-form", semester: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#semester-form", semester: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/semesters/#{semester}")

      html = render(show_live)
      assert html =~ "Semester updated successfully"
      assert html =~ "some updated name"
    end
  end
end
