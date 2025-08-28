defmodule LvsToolWeb.PageControllerTest do
  use LvsToolWeb.ConnCase

  import LvsTool.AccountsFixtures

  test "GET / redirects to /semesterentrys when user is logged in", %{conn: conn} do
    user = user_fixture()
    conn = log_in_user(conn, user)
    conn = get(conn, ~p"/")
    assert redirected_to(conn) == ~p"/semesterentrys"
  end

  test "GET / renders home page when user is not logged in", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Plane dein Semester"
  end
end
