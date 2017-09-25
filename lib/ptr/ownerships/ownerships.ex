defmodule Ptr.Ownerships do
  @moduledoc """
  The Ownerships context.
  """

  import Ecto.Query, warn: false
  import Ptr.Accounts.Account, only: [prefix: 1]
  import Ptr.Helpers

  alias Ptr.{Repo, Trail}
  alias Ptr.Accounts.Session
  alias Ptr.Ownerships.Owner

  @doc """
  Returns the list of owners.

  ## Examples

      iex> list_owners(%Account{}, %{})
      [%Owner{}, ...]

  """
  def list_owners(account, params) do
    Owner
    |> prefixed(account)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single owner.

  Raises `Ecto.NoResultsError` if the Owner does not exist.

  ## Examples

      iex> get_owner!(%Account{}, 123)
      %Owner{}

      iex> get_owner!(%Account{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_owner!(account, id) do
    Owner
    |> prefixed(account)
    |> Repo.get!(id)
  end

  @doc """
  Creates a owner.

  ## Examples

      iex> create_owner(%Session{}, %{field: value})
      {:ok, %Owner{}}

      iex> create_owner(%Session{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_owner(%Session{account: account, user: user}, attrs) do
    %Owner{}
    |> Owner.changeset(attrs)
    |> Map.put(:repo_opts, prefix: prefix(account))
    |> Trail.insert(prefix: prefix(account), originator: user)
  end

  @doc """
  Updates a owner.

  ## Examples

      iex> update_owner(%Session{}, owner, %{field: new_value})
      {:ok, %Owner{}}

      iex> update_owner(%Session{}, owner, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_owner(%Session{account: account, user: user}, %Owner{} = owner, attrs) do
    owner
    |> Owner.changeset(attrs)
    |> Trail.update(prefix: prefix(account), originator: user)
  end

  @doc """
  Deletes a Owner.

  ## Examples

      iex> delete_owner(%Session{}, owner)
      {:ok, %Owner{}}

      iex> delete_owner(%Session{}, owner)
      {:error, %Ecto.Changeset{}}

  """
  def delete_owner(%Session{account: account, user: user}, %Owner{} = owner) do
    Trail.delete(owner, prefix: prefix(account), originator: user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking owner changes.

  ## Examples

      iex> change_owner(owner)
      %Ecto.Changeset{source: %Owner{}}

  """
  def change_owner(%Owner{} = owner) do
    Owner.changeset(owner, %{})
  end
end
