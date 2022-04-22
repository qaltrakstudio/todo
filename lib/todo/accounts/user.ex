defmodule Todo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :type, Ecto.Enum, values: [:editor, :viewer]
    field :user_id, :string
    belongs_to :account, Todo.Accounts.Account

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :user_id, :type])
    |> validate_required([:first_name, :last_name, :email, :user_id, :type])
    |> unique_constraint(:user_id)
    |> unique_constraint(:email)
  end
end
