defmodule TodoApi.Schema do
  use Absinthe.Schema
  alias TodoApi.Types

  import_types(Absinthe.Type.Custom)
  import_types(Types.Task)

  query do
    import_fields(:task_queries)
  end
end
