defmodule LocWise.LocationsTest do
  use LocWise.DataCase

  alias LocWise.Locations

  describe "states" do
    alias LocWise.Locations.State

    import LocWise.LocationsFixtures

    @invalid_attrs %{acronym: nil, name: nil, region: nil}

    test "list_states/0 returns all states" do
      state = state_fixture()
      assert Locations.list_states() == [state]
    end

    test "get_state!/1 returns the state with given id" do
      state = state_fixture()
      assert Locations.get_state!(state.id) == state
    end

    test "create_state/1 with valid data creates a state" do
      valid_attrs = %{acronym: "some acronym", name: "some name", region: :north}

      assert {:ok, %State{} = state} = Locations.create_state(valid_attrs)
      assert state.acronym == "some acronym"
      assert state.name == "some name"
      assert state.region == :north
    end

    test "create_state/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Locations.create_state(@invalid_attrs)
    end

    test "update_state/2 with valid data updates the state" do
      state = state_fixture()
      update_attrs = %{acronym: "some updated acronym", name: "some updated name", region: :northeast}

      assert {:ok, %State{} = state} = Locations.update_state(state, update_attrs)
      assert state.acronym == "some updated acronym"
      assert state.name == "some updated name"
      assert state.region == :northeast
    end

    test "update_state/2 with invalid data returns error changeset" do
      state = state_fixture()
      assert {:error, %Ecto.Changeset{}} = Locations.update_state(state, @invalid_attrs)
      assert state == Locations.get_state!(state.id)
    end

    test "delete_state/1 deletes the state" do
      state = state_fixture()
      assert {:ok, %State{}} = Locations.delete_state(state)
      assert_raise Ecto.NoResultsError, fn -> Locations.get_state!(state.id) end
    end

    test "change_state/1 returns a state changeset" do
      state = state_fixture()
      assert %Ecto.Changeset{} = Locations.change_state(state)
    end
  end

  describe "cities" do
    alias LocWise.Locations.City

    import LocWise.LocationsFixtures

    @invalid_attrs %{name: nil}

    test "list_cities/0 returns all cities" do
      city = city_fixture()
      assert Locations.list_cities() == [city]
    end

    test "get_city!/1 returns the city with given id" do
      city = city_fixture()
      assert Locations.get_city!(city.id) == city
    end

    test "create_city/1 with valid data creates a city" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %City{} = city} = Locations.create_city(valid_attrs)
      assert city.name == "some name"
    end

    test "create_city/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Locations.create_city(@invalid_attrs)
    end

    test "update_city/2 with valid data updates the city" do
      city = city_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %City{} = city} = Locations.update_city(city, update_attrs)
      assert city.name == "some updated name"
    end

    test "update_city/2 with invalid data returns error changeset" do
      city = city_fixture()
      assert {:error, %Ecto.Changeset{}} = Locations.update_city(city, @invalid_attrs)
      assert city == Locations.get_city!(city.id)
    end

    test "delete_city/1 deletes the city" do
      city = city_fixture()
      assert {:ok, %City{}} = Locations.delete_city(city)
      assert_raise Ecto.NoResultsError, fn -> Locations.get_city!(city.id) end
    end

    test "change_city/1 returns a city changeset" do
      city = city_fixture()
      assert %Ecto.Changeset{} = Locations.change_city(city)
    end
  end
end
