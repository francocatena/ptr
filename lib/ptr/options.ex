defmodule Ptr.Options do
  @moduledoc """
  The Options context.
  """

  import Ecto.Query, warn: false
  import Ptr.Accounts.Account, only: [prefix: 1]
  import Ptr.Helpers

  alias Ptr.Repo
  alias Ptr.Trail
  alias Ptr.Accounts.{Account, Session}
  alias Ptr.Options.Variety

  @doc """
  Returns the list of varieties.

  ## Examples

      iex> list_varieties(%Account{})
      [%Variety{}, ...]

  """
  def list_varieties(account) do
    account
    |> list_varieties_query()
    |> Repo.all()
  end

  @doc """
  Returns the list of varieties paginated.

  ## Examples

      iex> list_varieties(%Account{}, %{})
      [%Variety{}, ...]

  """
  def list_varieties(account, params) do
    account
    |> list_varieties_query()
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single variety.

  Raises `Ecto.NoResultsError` if the Variety does not exist.

  ## Examples

      iex> get_variety!(%Account{}, 123)
      %Variety{}

      iex> get_variety!(%Account{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_variety!(account, id) do
    Variety
    |> prefixed(account)
    |> Repo.get!(id)
  end

  @doc """
  Creates a variety.

  ## Examples

      iex> create_variety(%Session{}, %{field: value})
      {:ok, %Variety{}}

      iex> create_variety(%Session{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_variety(%Session{account: account, user: user}, attrs) do
    account
    |> Variety.changeset(%Variety{}, attrs)
    |> Map.put(:repo_opts, prefix: prefix(account))
    |> Trail.insert(prefix: prefix(account), originator: user)
  end

  @doc """
  Updates a variety.

  ## Examples

      iex> update_variety(%Session{}, variety, %{field: new_value})
      {:ok, %Variety{}}

      iex> update_variety(%Session{}, variety, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_variety(%Session{account: account, user: user}, %Variety{} = variety, attrs) do
    account
    |> Variety.changeset(variety, attrs)
    |> Trail.update(prefix: prefix(account), originator: user)
  end

  @doc """
  Deletes a Variety.

  ## Examples

      iex> delete_variety(%Session{}, variety)
      {:ok, %Variety{}}

      iex> delete_variety(%Session{}, variety)
      {:error, %Ecto.Changeset{}}

  """
  def delete_variety(%Session{account: account, user: user}, %Variety{} = variety) do
    Trail.delete(variety, prefix: prefix(account), originator: user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking variety changes.

  ## Examples

      iex> change_variety(%Account{}, variety)
      %Ecto.Changeset{source: %Variety{}}

  """
  def change_variety(%Account{} = account, %Variety{} = variety) do
    Variety.changeset(account, variety, %{})
  end

  defp list_varieties_query(account) do
    query =
      from(
        v in Variety,
        group_by: v.id,
        left_join: l in assoc(v, :lots),
        select: %{v | lots_count: count(l.id)},
        order_by: v.name
      )

    prefixed(query, account)
  end

  alias Ptr.Options.Material

  @doc """
  Returns the list of materials.

  ## Examples

      iex> list_materials(%Account{})
      [%Material{}, ...]

  """
  def list_materials(account) do
    account
    |> list_materials_query()
    |> Repo.all()
  end

  @doc """
  Returns the list of materials paginated.

  ## Examples

      iex> list_materials(%Account{}, %{})
      [%Material{}, ...]

  """
  def list_materials(account, params) do
    account
    |> list_materials_query()
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single material.

  Raises `Ecto.NoResultsError` if the Material does not exist.

  ## Examples

      iex> get_material!(%Account{}, 123)
      %Material{}

      iex> get_material!(%Account{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_material!(account, id) do
    Material
    |> prefixed(account)
    |> Repo.get!(id)
  end

  @doc """
  Creates a material.

  ## Examples

      iex> create_material(%Session{}, %{field: value})
      {:ok, %Material{}}

      iex> create_material(%Session{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_material(%Session{account: account, user: user}, attrs) do
    account
    |> Material.changeset(%Material{}, attrs)
    |> Map.put(:repo_opts, prefix: prefix(account))
    |> Trail.insert(prefix: prefix(account), originator: user)
  end

  @doc """
  Updates a material.

  ## Examples

      iex> update_material(%Session{}, material, %{field: new_value})
      {:ok, %Material{}}

      iex> update_material(%Session{}, material, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_material(%Session{account: account, user: user}, %Material{} = material, attrs) do
    account
    |> Material.changeset(material, attrs)
    |> Trail.update(prefix: prefix(account), originator: user)
  end

  @doc """
  Deletes a Material.

  ## Examples

      iex> delete_material(%Session{}, material)
      {:ok, %Material{}}

      iex> delete_material(%Session{}, material)
      {:error, %Ecto.Changeset{}}

  """
  def delete_material(%Session{account: account, user: user}, %Material{} = material) do
    Trail.delete(material, prefix: prefix(account), originator: user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking material changes.

  ## Examples

      iex> change_material(%Account{}, material)
      %Ecto.Changeset{source: %Material{}}

  """
  def change_material(%Account{} = account, %Material{} = material) do
    Material.changeset(account, material, %{})
  end

  defp list_materials_query(account) do
    query =
      from(
        m in Material,
        group_by: m.id,
        left_join: v in assoc(m, :vessels),
        select: %{m | vessels_count: count(v.id)},
        order_by: m.name
      )

    prefixed(query, account)
  end
end
