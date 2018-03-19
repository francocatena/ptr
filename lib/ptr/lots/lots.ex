defmodule Ptr.Lots do
  @moduledoc """
  The Lots context.
  """

  import Ecto.Query, warn: false
  import Ptr.Accounts.Account, only: [prefix: 1]
  import Ptr.Helpers

  alias Ptr.Repo
  alias Ptr.Trail
  alias Ptr.Accounts.{Account, Session}
  alias Ptr.Lots.Lot

  @doc """
  Returns the list of lots.

  ## Examples

      iex> list_lots(%Account{}, %{})
      [%Lot{}, ...]

  """
  def list_lots(account, params) do
    lot_with_associations_query()
    |> prefixed(account)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single lot.

  Raises `Ecto.NoResultsError` if the Lot does not exist.

  ## Examples

      iex> get_lot!(%Account{}, 123)
      %Lot{}

      iex> get_lot!(%Account{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_lot!(account, id) do
    query =
      from(
        l in lot_with_associations_query(),
        left_join: p in assoc(l, :parts),
        select: %{l | parts_count: count(p.id)}
      )

    query
    |> prefixed(account)
    |> Repo.get!(id)
  end

  @doc """
  Creates a lot.

  ## Examples

      iex> create_lot(%Session{}, %{field: value})
      {:ok, %Lot{}}

      iex> create_lot(%Session{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lot(%Session{account: account, user: user}, attrs) do
    account
    |> Lot.changeset(%Lot{}, attrs)
    |> Map.put(:repo_opts, prefix: prefix(account))
    |> Trail.insert(prefix: prefix(account), originator: user)
  end

  @doc """
  Updates a lot.

  ## Examples

      iex> update_lot(%Session{}, lot, %{field: new_value})
      {:ok, %Lot{}}

      iex> update_lot(%Session{}, lot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lot(%Session{account: account, user: user}, %Lot{} = lot, attrs) do
    account
    |> Lot.changeset(lot, attrs)
    |> Trail.update(prefix: prefix(account), originator: user)
  end

  @doc """
  Deletes a Lot.

  ## Examples

      iex> delete_lot(%Session{}, lot)
      {:ok, %Lot{}}

      iex> delete_lot(%Session{}, lot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lot(%Session{account: account, user: user}, %Lot{} = lot) do
    Trail.delete(lot, prefix: prefix(account), originator: user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lot changes.

  ## Examples

      iex> change_lot(%Account{}, lot)
      %Ecto.Changeset{source: %Lot{}}

  """
  def change_lot(%Account{} = account, %Lot{} = lot) do
    Lot.changeset(account, lot, %{})
  end

  defp lot_with_associations_query() do
    from(
      l in Lot,
      join: c in assoc(l, :cellar),
      join: o in assoc(l, :owner),
      join: v in assoc(l, :variety),
      group_by: [l.id, c.id, o.id, v.id],
      preload: [cellar: c, owner: o, variety: v]
    )
  end

  alias Ptr.Lots.Part

  @doc """
  Returns the list of parts.

  ## Examples

      iex> list_parts(%Account{}, %Lot{}, %{})
      [%Part{}, ...]

  """
  def list_parts(account, lot, params) do
    part_with_associations_query()
    |> prefixed(account)
    |> where(lot_id: ^lot.id)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single part.

  Raises `Ecto.NoResultsError` if the Part does not exist.

  ## Examples

      iex> get_part!(%Account{}, %Lot{}, 123)
      %Part{}

      iex> get_part!(%Account{}, %Lot{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_part!(account, lot, id) do
    part_with_associations_query()
    |> prefixed(account)
    |> where(lot_id: ^lot.id)
    |> Repo.get!(id)
  end

  @doc """
  Creates a part.

  ## Examples

      iex> create_part(%Session{}, %{field: value})
      {:ok, %Part{}}

      iex> create_part(%Session{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_part(%Session{account: account, user: user}, attrs) do
    account
    |> Part.changeset(%Part{}, attrs)
    |> Map.put(:repo_opts, prefix: prefix(account))
    |> Trail.insert(prefix: prefix(account), originator: user)
  end

  @doc """
  Updates a part.

  ## Examples

      iex> update_part(%Session{}, part, %{field: new_value})
      {:ok, %Part{}}

      iex> update_part(%Session{}, part, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_part(%Session{account: account, user: user}, %Part{} = part, attrs) do
    account
    |> Part.changeset(part, attrs)
    |> Trail.update(prefix: prefix(account), originator: user)
  end

  @doc """
  Deletes a Part.

  ## Examples

      iex> delete_part(%Session{}, part)
      {:ok, %Part{}}

      iex> delete_part(%Session{}, part)
      {:error, %Ecto.Changeset{}}

  """
  def delete_part(%Session{account: account, user: user}, %Part{} = part) do
    Trail.delete(part, prefix: prefix(account), originator: user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking part changes.

  ## Examples

      iex> change_part(%Account{}, part)
      %Ecto.Changeset{source: %Part{}}

  """
  def change_part(%Account{} = account, %Part{} = part) do
    Part.changeset(account, part, %{})
  end

  defp part_with_associations_query do
    from(
      p in Part,
      join: l in assoc(p, :lot),
      join: v in assoc(p, :vessel),
      preload: [lot: l, vessel: v]
    )
  end
end
