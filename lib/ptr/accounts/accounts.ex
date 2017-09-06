defmodule Ptr.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query

  alias Ptr.{Repo, Trail}
  alias Ptr.Accounts.Account

  @doc """
  Returns the account prefix (Database schema name)

  ## Examples

      iex> prefix(%Account{})
      "t_account_prefix"

  """
  defdelegate prefix(account), to: Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}, opts \\ [create_schema: true])

  def create_account(attrs, create_schema: true) do
    attrs
    |> create_account(create_schema: false)
    |> Account.after_create()
  end

  def create_account(attrs, _) do
    %Account{}
    |> Account.create_changeset(attrs)
    |> Trail.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Trail.update()
  end

  @doc """
  Deletes a Account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    account
    |> Trail.delete()
    |> Account.after_delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end

  alias Ptr.Accounts.{Auth, User, Password}

  @doc """
  Returns the list of users for the account.

  ## Examples

      iex> list_users(1)
      [%User{}, ...]

  """
  def list_users(account, params) do
    User
    |> where(account_id: ^account.id)
    |> order_by(asc: :email)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist on the account.

  ## Examples

      iex> get_user!(%Account{id: 1}, 123)
      %User{}

      iex> get_user!(%Account{id: 2}, 123)
      ** (Ecto.NoResultsError)

  """
  def get_user!(account, id) do
    Repo.get_by!(User, id: id, account_id: account.id)
  end

  @doc """
  Gets a single user by his token or email.

  Returns nil if a User with this token does not exist or the token is expired.

  ## Examples

      iex> get_user(token: "qCRc-NABnQgqX2oPiOThY..")
      %User{}

      iex> get_user(email: "some@email.com")
      %User{}

      iex> get_user(token: "qQdvYYT8gpHJVXrIdcDDc..")
      nil

  """
  def get_user(token: token), do: Password.get_user_by_token(token)
  def get_user(email: email), do: Repo.get_by(User, email: email)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%Account{}, %{field: value})
      {:ok, %User{}}

      iex> create_user(%Account{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(account, attrs) do
    %User{account_id: account.id}
    |> User.create_changeset(attrs)
    |> Trail.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Trail.update()
  end

  @doc """
  Updates a user password.

  ## Examples

      iex> update_user_password(user, %{password: "newpass", password_confirmation: "newpass"})
      {:ok, %User{}}

      iex> update_user_password(user, %{password: "newpass", password_confirmation: "wrong"})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(%User{} = user, attrs) do
    user
    |> User.password_reset_changeset(attrs)
    |> Trail.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Trail.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user), do: User.changeset(user, %{})

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user password changes.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user_password(%User{} = user) do
    User.password_reset_changeset(user, %{})
  end

  @doc """
  Authenticates a user.

  ## Examples

    iex> authenticate_by_email_and_password("john@doe.com", "123")
    {:ok, %User{}}

    iex> authenticate_by_email_and_password("john@doe.com", "wrong")
    {:error, :unauthorized}

  """
  def authenticate_by_email_and_password(email, password) do
    Auth.authenticate_by_email_and_password(email, password)
  end

  @doc """
  Sends password reset email to a user.

  ## Examples

      iex> password_reset(user)
      {:ok, %User{}}

  """
  def password_reset(user), do: Password.reset(user)
end
