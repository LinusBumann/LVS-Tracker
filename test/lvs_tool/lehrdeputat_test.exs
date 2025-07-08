defmodule LvsTool.LehrdeputatTest do
  use LvsTool.DataCase

  alias LvsTool.Lehrdeputat

  describe "semesters" do
    alias LvsTool.Lehrdeputat.Semester

    import LvsTool.LehrdeputatFixtures

    @invalid_attrs %{name: nil}

    test "list_semesters/0 returns all semesters" do
      semester = semester_fixture()
      assert Lehrdeputat.list_semesters() == [semester]
    end

    test "get_semester!/1 returns the semester with given id" do
      semester = semester_fixture()
      assert Lehrdeputat.get_semester!(semester.id) == semester
    end

    test "create_semester/1 with valid data creates a semester" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Semester{} = semester} = Lehrdeputat.create_semester(valid_attrs)
      assert semester.name == "some name"
    end

    test "create_semester/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lehrdeputat.create_semester(@invalid_attrs)
    end

    test "update_semester/2 with valid data updates the semester" do
      semester = semester_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Semester{} = semester} = Lehrdeputat.update_semester(semester, update_attrs)
      assert semester.name == "some updated name"
    end

    test "update_semester/2 with invalid data returns error changeset" do
      semester = semester_fixture()
      assert {:error, %Ecto.Changeset{}} = Lehrdeputat.update_semester(semester, @invalid_attrs)
      assert semester == Lehrdeputat.get_semester!(semester.id)
    end

    test "delete_semester/1 deletes the semester" do
      semester = semester_fixture()
      assert {:ok, %Semester{}} = Lehrdeputat.delete_semester(semester)
      assert_raise Ecto.NoResultsError, fn -> Lehrdeputat.get_semester!(semester.id) end
    end

    test "change_semester/1 returns a semester changeset" do
      semester = semester_fixture()
      assert %Ecto.Changeset{} = Lehrdeputat.change_semester(semester)
    end
  end
end
