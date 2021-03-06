defmodule Ptr.Cellars do
  @moduledoc """
  The Cellars context.
  """

  import Ecto.Query, warn: false
  import Ptr.Accounts.Account, only: [prefix: 1]
  import Ptr.Helpers

  alias Ptr.{Repo, Trail}
  alias Ptr.Accounts.{Account, Session}
  alias Ptr.Cellars.Cellar

  @doc """
  Returns the list of cellars.

  ## Examples

      iex> list_cellars(%Account{})
      [%Cellar{}, ...]

  """
  def list_cellars(account) do
    account
    |> list_cellars_query()
    |> Repo.all()
  end

  @doc """
  Returns the list of cellars paginated.

  ## Examples

      iex> list_cellars(%Account{}, %{})
      [%Cellar{}, ...]

  """
  def list_cellars(account, params) do
    account
    |> list_cellars_query()
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single cellar.

  Raises `Ecto.NoResultsError` if the Cellar does not exist.

  ## Examples

      iex> get_cellar!(%Account{}, 123)
      %Cellar{}

      iex> get_cellar!(%Account{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_cellar!(account, id) do
    query =
      from(
        c in Cellar,
        group_by: c.id,
        left_join: v in assoc(c, :vessels),
        select: %{c | vessels_count: count(v.id)}
      )

    query
    |> prefixed(account)
    |> Repo.get!(id)
  end

  @doc """
  Creates a cellar.

  ## Examples

      iex> create_cellar(%Session{}, %{field: value})
      {:ok, %Cellar{}}

      iex> create_cellar(%Session{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cellar(%Session{account: account, user: user}, attrs) do
    account
    |> Cellar.changeset(%Cellar{}, attrs)
    |> Map.put(:repo_opts, prefix: prefix(account))
    |> Trail.insert(prefix: prefix(account), originator: user)
  end

  @doc """
  Updates a cellar.

  ## Examples

      iex> update_cellar(%Session{}, cellar, %{field: new_value})
      {:ok, %Cellar{}}

      iex> update_cellar(%Session{}, cellar, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cellar(%Session{account: account, user: user}, %Cellar{} = cellar, attrs) do
    account
    |> Cellar.changeset(cellar, attrs)
    |> Trail.update(prefix: prefix(account), originator: user)
  end

  @doc """
  Deletes a Cellar.

  ## Examples

      iex> delete_cellar(%Session{}, cellar)
      {:ok, %Cellar{}}

      iex> delete_cellar(%Session{}, cellar)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cellar(%Session{account: account, user: user}, %Cellar{} = cellar) do
    Trail.delete(cellar, prefix: prefix(account), originator: user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cellar changes.

  ## Examples

      iex> change_cellar(%Account{}, cellar)
      %Ecto.Changeset{source: %Cellar{}}

  """
  def change_cellar(%Account{} = account, %Cellar{} = cellar) do
    Cellar.changeset(account, cellar, %{})
  end

  alias Ptr.Cellars.Vessel

  @doc """
  Returns the list of vessels on a given cellar.

  ## Examples

      iex> list_vessels(%Account{}, %Cellar{})
      [%Vessel{}, ...]

  """
  def list_vessels(account, cellar) do
    account
    |> list_vessels_query(cellar)
    |> Repo.all()
  end

  @doc """
  Returns the list of vessels on a given cellar.

  ## Examples

      iex> list_vessels(%Account{}, %Cellar{}, %{})
      [%Vessel{}, ...]

  """
  def list_vessels(account, cellar, params) do
    account
    |> list_vessels_query(cellar)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single vessel.

  Raises `Ecto.NoResultsError` if the Vessel does not exist.

  ## Examples

      iex> get_vessel!(%Account{}, 123)
      %Vessel{}

      iex> get_vessel!(%Account{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_vessel!(account, id) do
    account
    |> get_vessel_query()
    |> Repo.get!(id)
    |> Vessel.calculate_usage()
  end

  @doc """
  Gets a single vessel from a cellar.

  Raises `Ecto.NoResultsError` if the Vessel does not exist.

  ## Examples

      iex> get_vessel!(%Account{}, %Cellar{}, 123)
      %Vessel{}

      iex> get_vessel!(%Account{}, %Cellar{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_vessel!(account, cellar, id) do
    account
    |> get_vessel_query()
    |> where(cellar_id: ^cellar.id)
    |> Repo.get!(id)
    |> Vessel.calculate_usage()
  end

  @doc """
  Creates a vessel.

  ## Examples

      iex> create_vessel(%Session{}, %{field: value})
      {:ok, %Vessel{}}

      iex> create_vessel(%Session{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vessel(%Session{account: account, user: user}, attrs) do
    account
    |> Vessel.changeset(%Vessel{}, attrs)
    |> Map.put(:repo_opts, prefix: prefix(account))
    |> Trail.insert(prefix: prefix(account), originator: user)
  end

  @doc """
  Updates a vessel.

  ## Examples

      iex> update_vessel(%Session{}, vessel, %{field: new_value})
      {:ok, %Vessel{}}

      iex> update_vessel(%Session{}, vessel, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vessel(%Session{account: account, user: user}, %Vessel{} = vessel, attrs) do
    account
    |> Vessel.changeset(vessel, attrs)
    |> Trail.update(prefix: prefix(account), originator: user)
  end

  @doc """
  Deletes a Vessel.

  ## Examples

      iex> delete_vessel(%Session{}, vessel)
      {:ok, %Vessel{}}

      iex> delete_vessel(%Session{}, vessel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vessel(%Session{account: account, user: user}, %Vessel{} = vessel) do
    Trail.delete(vessel, prefix: prefix(account), originator: user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vessel changes.

  ## Examples

      iex> change_vessel(%Account{}, vessel)
      %Ecto.Changeset{source: %Vessel{}}

  """
  def change_vessel(%Account{} = account, %Vessel{} = vessel) do
    Vessel.changeset(account, vessel, %{})
  end

  defp list_cellars_query(account) do
    query =
      from(
        c in Cellar,
        group_by: c.id,
        left_join: l in assoc(c, :lots),
        select: %{c | lots_count: count(l.id)},
        order_by: c.identifier
      )

    prefixed(query, account)
  end

  defp list_vessels_query(account, cellar) do
    query =
      from(
        v in Vessel,
        left_join: p in assoc(v, :parts),
        left_join: m in assoc(v, :material),
        select: %{v | usage: coalesce(sum(p.amount), 0)},
        where: [cellar_id: ^cellar.id],
        group_by: [v.id, m.id],
        order_by: v.identifier,
        preload: [material: m]
      )

    prefixed(query, account)
  end

  defp get_vessel_query(account) do
    query =
      from(
        v in Vessel,
        left_join: p in assoc(v, :parts),
        left_join: m in assoc(v, :material),
        left_join: l in assoc(p, :lot),
        preload: [material: m, parts: {p, lot: l}]
      )

    prefixed(query, account)
  end
end
