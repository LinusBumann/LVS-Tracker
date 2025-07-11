defmodule LvsTool.CoursesTest do
  use LvsTool.DataCase

  alias LvsTool.Courses

  describe "standardcoursetypes" do
    alias LvsTool.Courses.Standardcoursetype

    import LvsTool.CoursesFixtures

    @invalid_attrs %{name: nil, imputationfactor: nil, abbreviation: nil}

    test "list_standardcoursetypes/0 returns all standardcoursetypes" do
      standardcoursetype = standardcoursetype_fixture()
      assert Courses.list_standardcoursetypes() == [standardcoursetype]
    end

    test "get_standardcoursetype!/1 returns the standardcoursetype with given id" do
      standardcoursetype = standardcoursetype_fixture()
      assert Courses.get_standardcoursetype!(standardcoursetype.id) == standardcoursetype
    end

    test "create_standardcoursetype/1 with valid data creates a standardcoursetype" do
      valid_attrs = %{name: "some name", imputationfactor: 120.5, abbreviation: "some abbreviation"}

      assert {:ok, %Standardcoursetype{} = standardcoursetype} = Courses.create_standardcoursetype(valid_attrs)
      assert standardcoursetype.name == "some name"
      assert standardcoursetype.imputationfactor == 120.5
      assert standardcoursetype.abbreviation == "some abbreviation"
    end

    test "create_standardcoursetype/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Courses.create_standardcoursetype(@invalid_attrs)
    end

    test "update_standardcoursetype/2 with valid data updates the standardcoursetype" do
      standardcoursetype = standardcoursetype_fixture()
      update_attrs = %{name: "some updated name", imputationfactor: 456.7, abbreviation: "some updated abbreviation"}

      assert {:ok, %Standardcoursetype{} = standardcoursetype} = Courses.update_standardcoursetype(standardcoursetype, update_attrs)
      assert standardcoursetype.name == "some updated name"
      assert standardcoursetype.imputationfactor == 456.7
      assert standardcoursetype.abbreviation == "some updated abbreviation"
    end

    test "update_standardcoursetype/2 with invalid data returns error changeset" do
      standardcoursetype = standardcoursetype_fixture()
      assert {:error, %Ecto.Changeset{}} = Courses.update_standardcoursetype(standardcoursetype, @invalid_attrs)
      assert standardcoursetype == Courses.get_standardcoursetype!(standardcoursetype.id)
    end

    test "delete_standardcoursetype/1 deletes the standardcoursetype" do
      standardcoursetype = standardcoursetype_fixture()
      assert {:ok, %Standardcoursetype{}} = Courses.delete_standardcoursetype(standardcoursetype)
      assert_raise Ecto.NoResultsError, fn -> Courses.get_standardcoursetype!(standardcoursetype.id) end
    end

    test "change_standardcoursetype/1 returns a standardcoursetype changeset" do
      standardcoursetype = standardcoursetype_fixture()
      assert %Ecto.Changeset{} = Courses.change_standardcoursetype(standardcoursetype)
    end
  end
end
