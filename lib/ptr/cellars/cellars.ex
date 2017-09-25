defmodule Ptr.Cellars do
  @moduledoc """
  The Cellars context.
  """

  import Ecto.Query, warn: false
  import Ptr.Accounts.Account, only: [prefix: 1]
  import Ptr.Helpers

  alias Ptr.{Repo, Trail}
  alias Ptr.Accounts.Session
  alias Ptr.Cellars.Cellar

  @doc """
  Returns the list of cellars.

  ## Examples

      iex> list_cellars(%Account{}, %{})
      [%Cellar{}, ...]

  """
  def list_cellars(account, params) do
    Cellar
    |> prefixed(account)
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
    Cellar
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
    %Cellar{}
    |> Cellar.changeset(attrs)
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
    cellar
    |> Cellar.changeset(attrs)
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

      iex> change_cellar(cellar)
      %Ecto.Changeset{source: %Cellar{}}

  """
  def change_cellar(%Cellar{} = cellar) do
    Cellar.changeset(cellar, %{})
  end
end
