defmodule Saas.Message do
  use AccessCms.Schema
  import Ecto.Changeset

  embedded_schema do
    field :type, :string, default: "db"
    field :title, :string
    field :body, :string
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:type, :title, :body])
    |> validate_required([:title])
  end
end
