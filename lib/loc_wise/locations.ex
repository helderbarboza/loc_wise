defmodule LocWise.Locations do
  @moduledoc """
  The Locations context.
  """

  import Ecto.Query, warn: false

  alias LocWise.Locations.City
  alias LocWise.Locations.State
  alias LocWise.Repo

  @doc """
  Returns the paginated list of states.

  ## Examples

      iex> list_states(params)
      {:ok, {[%State{}, ...], %Flop.Meta{}}}

  """
  def list_states(params) do
    Flop.validate_and_run(
      from(c in State, preload: :cities),
      params,
      for: State,
      repo: Repo
    )
  end

  @doc """
  Returns the list of states as options to be used on inputs.

  ## Examples

      iex> list_states_options()
      [{"Bahia", 1}, {"Ceará", 2}, ...]

  """
  def list_states_options do
    Repo.all(
      from s in State,
        select: {s.name, s.id},
        order_by: {:asc, s.name}
    )
  end

  @doc """
  Gets a single state.

  Raises `Ecto.NoResultsError` if the State does not exist.

  ## Examples

      iex> get_state!(123)
      %State{}

      iex> get_state!(456)
      ** (Ecto.NoResultsError)

  """
  def get_state!(id), do: Repo.get!(State, id)

  @doc """
  Creates a state.

  ## Examples

      iex> create_state(%{field: value})
      {:ok, %State{}}

      iex> create_state(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_state(attrs \\ %{}) do
    %State{}
    |> State.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a state.

  ## Examples

      iex> update_state(state, %{field: new_value})
      {:ok, %State{}}

      iex> update_state(state, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_state(%State{} = state, attrs) do
    state
    |> State.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a state.

  ## Examples

      iex> delete_state(state)
      {:ok, %State{}}

      iex> delete_state(state)
      {:error, %Ecto.Changeset{}}

  """
  def delete_state(%State{} = state) do
    Repo.delete(state)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking state changes.

  ## Examples

      iex> change_state(state)
      %Ecto.Changeset{data: %State{}}

  """
  def change_state(%State{} = state, attrs \\ %{}) do
    State.changeset(state, attrs)
  end

  def count_states do
    Repo.one(from State, select: count())
  end

  @doc """
  Returns the paginated list of cities.

  ## Examples

      iex> list_cities(params)
      {:ok, {[%City{}, ...], %Flop.Meta{}}}

  """
  def list_cities(params) do
    Flop.validate_and_run(
      from(c in City, preload: :state),
      params,
      for: City,
      repo: Repo
    )
  end

  @doc """
  Gets a single city.

  Raises `Ecto.NoResultsError` if the City does not exist.

  ## Examples

      iex> get_city!(123)
      %City{}

      iex> get_city!(456)
      ** (Ecto.NoResultsError)

  """
  def get_city!(id) do
    Repo.one!(from c in City, where: [id: ^id], preload: :state)
  end

  @doc """
  Creates a city.

  ## Examples

      iex> create_city(%{field: value})
      {:ok, %City{}}

      iex> create_city(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_city(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a city.

  ## Examples

      iex> update_city(city, %{field: new_value})
      {:ok, %City{}}

      iex> update_city(city, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_city(%City{} = city, attrs) do
    city
    |> City.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a city.

  ## Examples

      iex> delete_city(city)
      {:ok, %City{}}

      iex> delete_city(city)
      {:error, %Ecto.Changeset{}}

  """
  def delete_city(%City{} = city) do
    Repo.delete(city)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking city changes.

  ## Examples

      iex> change_city(city)
      %Ecto.Changeset{data: %City{}}

  """
  def change_city(%City{} = city, attrs \\ %{}) do
    City.changeset(city, attrs)
  end

  def count_cities do
    Repo.one(from City, select: count())
  end
end
