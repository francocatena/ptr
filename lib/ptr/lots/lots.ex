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
    lot_with_associations_query()
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

  defp lot_with_associations_query do
    from(
      l in Lot,
      join: o in assoc(l, :owner),
      join: v in assoc(l, :variety),
      preload: [owner: o, variety: v]
    )
  end
end
