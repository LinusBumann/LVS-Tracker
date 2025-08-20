defmodule LvsTool.SubmissionperiodsTest do
  use LvsTool.DataCase

  alias LvsTool.Submissionperiods

  describe "submissionperiods" do
    alias LvsTool.Submissionperiods.Submissionperiod

    import LvsTool.SubmissionperiodsFixtures

    @invalid_attrs %{name: nil, startdate: nil, enddate: nil}

    test "list_submissionperiods/0 returns all submissionperiods" do
      submissionperiod = submissionperiod_fixture()
      assert Submissionperiods.list_submissionperiods() == [submissionperiod]
    end

    test "get_submissionperiod!/1 returns the submissionperiod with given id" do
      submissionperiod = submissionperiod_fixture()
      assert Submissionperiods.get_submissionperiod!(submissionperiod.id) == submissionperiod
    end

    test "create_submissionperiod/1 with valid data creates a submissionperiod" do
      valid_attrs = %{name: "some name", startdate: ~U[2025-08-19 10:39:00Z], enddate: ~U[2025-08-19 10:39:00Z]}

      assert {:ok, %Submissionperiod{} = submissionperiod} = Submissionperiods.create_submissionperiod(valid_attrs)
      assert submissionperiod.name == "some name"
      assert submissionperiod.startdate == ~U[2025-08-19 10:39:00Z]
      assert submissionperiod.enddate == ~U[2025-08-19 10:39:00Z]
    end

    test "create_submissionperiod/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Submissionperiods.create_submissionperiod(@invalid_attrs)
    end

    test "update_submissionperiod/2 with valid data updates the submissionperiod" do
      submissionperiod = submissionperiod_fixture()
      update_attrs = %{name: "some updated name", startdate: ~U[2025-08-20 10:39:00Z], enddate: ~U[2025-08-20 10:39:00Z]}

      assert {:ok, %Submissionperiod{} = submissionperiod} = Submissionperiods.update_submissionperiod(submissionperiod, update_attrs)
      assert submissionperiod.name == "some updated name"
      assert submissionperiod.startdate == ~U[2025-08-20 10:39:00Z]
      assert submissionperiod.enddate == ~U[2025-08-20 10:39:00Z]
    end

    test "update_submissionperiod/2 with invalid data returns error changeset" do
      submissionperiod = submissionperiod_fixture()
      assert {:error, %Ecto.Changeset{}} = Submissionperiods.update_submissionperiod(submissionperiod, @invalid_attrs)
      assert submissionperiod == Submissionperiods.get_submissionperiod!(submissionperiod.id)
    end

    test "delete_submissionperiod/1 deletes the submissionperiod" do
      submissionperiod = submissionperiod_fixture()
      assert {:ok, %Submissionperiod{}} = Submissionperiods.delete_submissionperiod(submissionperiod)
      assert_raise Ecto.NoResultsError, fn -> Submissionperiods.get_submissionperiod!(submissionperiod.id) end
    end

    test "change_submissionperiod/1 returns a submissionperiod changeset" do
      submissionperiod = submissionperiod_fixture()
      assert %Ecto.Changeset{} = Submissionperiods.change_submissionperiod(submissionperiod)
    end
  end
end
