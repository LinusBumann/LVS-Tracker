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

  describe "standardcoursenames" do
    alias LvsTool.Courses.Standardcoursename

    import LvsTool.CoursesFixtures

    @invalid_attrs %{name: nil}

    test "list_standardcoursenames/0 returns all standardcoursenames" do
      standardcoursename = standardcoursename_fixture()
      assert Courses.list_standardcoursenames() == [standardcoursename]
    end

    test "get_standardcoursename!/1 returns the standardcoursename with given id" do
      standardcoursename = standardcoursename_fixture()
      assert Courses.get_standardcoursename!(standardcoursename.id) == standardcoursename
    end

    test "create_standardcoursename/1 with valid data creates a standardcoursename" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Standardcoursename{} = standardcoursename} = Courses.create_standardcoursename(valid_attrs)
      assert standardcoursename.name == "some name"
    end

    test "create_standardcoursename/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Courses.create_standardcoursename(@invalid_attrs)
    end

    test "update_standardcoursename/2 with valid data updates the standardcoursename" do
      standardcoursename = standardcoursename_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Standardcoursename{} = standardcoursename} = Courses.update_standardcoursename(standardcoursename, update_attrs)
      assert standardcoursename.name == "some updated name"
    end

    test "update_standardcoursename/2 with invalid data returns error changeset" do
      standardcoursename = standardcoursename_fixture()
      assert {:error, %Ecto.Changeset{}} = Courses.update_standardcoursename(standardcoursename, @invalid_attrs)
      assert standardcoursename == Courses.get_standardcoursename!(standardcoursename.id)
    end

    test "delete_standardcoursename/1 deletes the standardcoursename" do
      standardcoursename = standardcoursename_fixture()
      assert {:ok, %Standardcoursename{}} = Courses.delete_standardcoursename(standardcoursename)
      assert_raise Ecto.NoResultsError, fn -> Courses.get_standardcoursename!(standardcoursename.id) end
    end

    test "change_standardcoursename/1 returns a standardcoursename changeset" do
      standardcoursename = standardcoursename_fixture()
      assert %Ecto.Changeset{} = Courses.change_standardcoursename(standardcoursename)
    end
  end

  describe "studygroups" do
    alias LvsTool.Courses.Studygroup

    import LvsTool.CoursesFixtures

    @invalid_attrs %{name: nil}

    test "list_studygroups/0 returns all studygroups" do
      studygroup = studygroup_fixture()
      assert Courses.list_studygroups() == [studygroup]
    end

    test "get_studygroup!/1 returns the studygroup with given id" do
      studygroup = studygroup_fixture()
      assert Courses.get_studygroup!(studygroup.id) == studygroup
    end

    test "create_studygroup/1 with valid data creates a studygroup" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Studygroup{} = studygroup} = Courses.create_studygroup(valid_attrs)
      assert studygroup.name == "some name"
    end

    test "create_studygroup/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Courses.create_studygroup(@invalid_attrs)
    end

    test "update_studygroup/2 with valid data updates the studygroup" do
      studygroup = studygroup_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Studygroup{} = studygroup} = Courses.update_studygroup(studygroup, update_attrs)
      assert studygroup.name == "some updated name"
    end

    test "update_studygroup/2 with invalid data returns error changeset" do
      studygroup = studygroup_fixture()
      assert {:error, %Ecto.Changeset{}} = Courses.update_studygroup(studygroup, @invalid_attrs)
      assert studygroup == Courses.get_studygroup!(studygroup.id)
    end

    test "delete_studygroup/1 deletes the studygroup" do
      studygroup = studygroup_fixture()
      assert {:ok, %Studygroup{}} = Courses.delete_studygroup(studygroup)
      assert_raise Ecto.NoResultsError, fn -> Courses.get_studygroup!(studygroup.id) end
    end

    test "change_studygroup/1 returns a studygroup changeset" do
      studygroup = studygroup_fixture()
      assert %Ecto.Changeset{} = Courses.change_studygroup(studygroup)
    end
  end
end
