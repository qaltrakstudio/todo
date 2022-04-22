defmodule Todo.Admins.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "admins" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :type, Ecto.Enum, values: [:platform, :service]
    field :user_id, :string

    timestamps()
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [:first_name, :last_name, :email, :user_id, :type])
    |> validate_required([:first_name, :last_name, :email, :user_id, :type])
    |> unique_constraint(:user_id)
    |> unique_constraint(:email)
  end
end
