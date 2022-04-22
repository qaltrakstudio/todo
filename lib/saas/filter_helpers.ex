defmodule Saas.FilterHelpers do
  @moduledoc """
  Provides input generators for filter sidebar.
  """

  use Phoenix.HTML

  defp message(text), do: text

  @doc """
  Generates a select box for a `belongs_to` association.

  ## Example

      iex> params = %{"post" => %{"category_id_equals" => 1}}
      ...> filter_assoc_select(:post, :category_id, [{"Articles", 1}], params) |> safe_to_string()
      "<select id=\\"post_category_id_equals\\" name=\\"post[category_id_equals]\\"><option value=\\"\\">Choose one</option><option value=\\"1\\" selected>Articles</option></select>"
  """
  def filter_assoc_select(prefix, field, options, params) do
    select(
      prefix,
      :"#{field}_equals",
      options,
      value: params[to_string(prefix)]["#{field}_equals"],
      prompt: message("Choose one")
    )
  end

  @doc """
  Generates a "contains/equals" filter type select box for a given `string` or
  `text` field.

  ## Example

      iex> params = %{"post" => %{"title_contains" => "test"}}
      ...> filter_select(:post, :title, params) |> safe_to_string()
      "<select class=\\"select select-bordered\\" id=\\"filters_\\" name=\\"filters[]\\"><option value=\\"post[title_contains]\\" selected>Contains</option><option value=\\"post[title_equals]\\">Equals</option></select>"
  """
  def filter_select(prefix, field, params) do
    prefix_str = to_string(prefix)
    {selected, _value} = find_param(params[prefix_str], field)

    opts = [
      {message("Contains"), "#{prefix}[#{field}_contains]"},
      {message("Equals"), "#{prefix}[#{field}_equals]"}
    ]

    select(:filters, "", opts, class: "select select-bordered", value: "#{prefix}[#{selected}]")
  end

  @doc """
  Generates a "before/after" filter type select box for a given `date` or
  `datetime` field.

  ## Example

      iex> params = %{"post" => %{"updated_at_after" => "01/01/2019"}}
      ...> filter_date_select(:post, :updated_at, params) |> safe_to_string()
      "<select class=\\"focus:border-blue-400 focus:ring-2 focus:ring-blue-200 focus:outline-none w-full text-base placeholder-gray-400 border border-gray-300 rounded py-1.5 px-3\\" id=\\"filters_\\" name=\\"filters[]\\"><option value=\\"post[updated_at_before]\\">Before</option><option value=\\"post[updated_at_after]\\" selected>After</option></select>"
  """
  def filter_date_select(prefix, field, params) do
    prefix_str = to_string(prefix)
    {selected, _value} = find_param(params[prefix_str], field)

    opts = [
      {message("Before"), "#{prefix}[#{field}_before]"},
      {message("After"), "#{prefix}[#{field}_after]"}
    ]

    select(:filters, "", opts, class: "select select-bordered", value: "#{prefix}[#{selected}]")
  end

  @doc """
  Generates a number filter type select box for a given `number` field.

  ## Example

      iex> params = %{"post" => %{"rating_greater_than" => 0}}
      ...> number_filter_select(:post, :rating, params) |> safe_to_string()
      "<select class=\\"focus:border-blue-400 focus:ring-2 focus:ring-blue-200 focus:outline-none w-full text-base placeholder-gray-400 border border-gray-300 rounded py-1.5 px-3\\" id=\\"filters_\\" name=\\"filters[]\\"><option value=\\"post[rating_equals]\\">Equals</option><option value=\\"post[rating_greater_than]\\" selected>Greater Than</option><option value=\\"post[rating_greater_than_or]\\">Greater Than Or Equal</option><option value=\\"post[rating_less_than]\\">Less Than</option></select>"
  """
  def number_filter_select(prefix, field, params) do
    prefix_str = to_string(prefix)
    {selected, _value} = find_param(params[prefix_str], field)

    opts = [
      {message("Equals"), "#{prefix}[#{field}_equals]"},
      {message("Greater Than"), "#{prefix}[#{field}_greater_than]"},
      {message("Greater Than Or Equal"), "#{prefix}[#{field}_greater_than_or]"},
      {message("Less Than"), "#{prefix}[#{field}_less_than]"}
    ]

    select(:filters, "", opts, class: "select select-bordered", value: "#{prefix}[#{selected}]")
  end

  @doc """
  Generates a filter input for a number field.

  ## Example

      iex> params = %{"post" => %{"rating_equals" => 5}}
      ...> filter_number_input(:post, :rating, params) |> safe_to_string()
      "<input class=\\"focus:border-blue-400 focus:ring-2 focus:ring-blue-200 focus:outline-none w-full text-base placeholder-gray-400 border border-gray-300 rounded py-1.5 px-3\\" id=\\"post_rating_equals\\" name=\\"post[rating_equals]\\" type=\\"number\\" value=\\"5\\">"
  """
  def filter_number_input(prefix, field, params) do
    prefix_str = to_string(prefix)
    {name, value} = find_param(params[prefix_str], field, :number)
    text_input(prefix, String.to_atom(name), value: value, type: "number", class: "input input-bordered")
  end

  @doc """
  Generates a filter input for a string field.

  ## Example

      iex> params = %{"post" => %{"title_contains" => "test"}}
      iex> filter_string_input(:post, :title, params) |> safe_to_string()
      "<input class=\\"focus:border-blue-400 focus:ring-2 focus:ring-blue-200 focus:outline-none w-full text-base placeholder-gray-400 border border-gray-300 rounded py-1.5 px-3\\" id=\\"post_title_contains\\" name=\\"post[title_contains]\\" type=\\"text\\" value=\\"test\\">"
  """
  # @spec filter_string_input(prefix, field, map) :: Phoenix.HTML.safe()
  def filter_string_input(prefix, field, params) do
    prefix_str = to_string(prefix)
    {name, value} = find_param(params[prefix_str], field)
    text_input(prefix, String.to_atom(name), value: value, class: "input input-bordered")
  end

  @doc """
  Generates a filter datepicker input.

  ## Example

      iex> params = %{"post" => %{"inserted_at_between" => %{"start" => "01/01/2018", "end" => "01/31/2018"}}}
      ...> filter_date_input(:post, :inserted_at, params) |> safe_to_string()
      "<input class=\\"datepicker start\\" name=\\"post[inserted_at_between][start]\\" placeholder=\\"Select Start Date\\" type=\\"text\\" value=\\"01/01/2018\\"><input class=\\"datepicker end\\" name=\\"post[inserted_at_between][end]\\" placeholder=\\"Select End Date\\" type=\\"text\\" value=\\"01/31/2018\\">"

      iex> params = %{"post" => %{"inserted_at_between" => %{"start" => "01/01/2018", "end" => "01/31/2018"}}}
      ...> filter_date_input(:post, :inserted_at, params, :range) |> safe_to_string()
      "<input class=\\"datepicker start\\" name=\\"post[inserted_at_between][start]\\" placeholder=\\"Select Start Date\\" type=\\"text\\" value=\\"01/01/2018\\"><input class=\\"datepicker end\\" name=\\"post[inserted_at_between][end]\\" placeholder=\\"Select End Date\\" type=\\"text\\" value=\\"01/31/2018\\">"

      iex> params = %{"post" => %{"inserted_at_before" => "01/01/2018"}}
      ...> filter_date_input(:post, :inserted_at, params, :select) |> safe_to_string()
      "<input class=\\"datepicker\\" name=\\"post[inserted_at_before]\\" placeholder=\\"Select Date\\" type=\\"text\\" value=\\"01/01/2018\\">"

      iex> params = %{"post" => %{"inserted_at_after" => "01/01/2018"}}
      ...> filter_date_input(:post, :inserted_at, params, :select) |> safe_to_string()
      "<input class=\\"datepicker\\" name=\\"post[inserted_at_after]\\" placeholder=\\"Select Date\\" type=\\"text\\" value=\\"01/01/2018\\">"
  """
  def filter_date_input(prefix, field, params, input_type \\ :range)

  def filter_date_input(prefix, field, params, :range) do
    prefix = to_string(prefix)
    field = to_string(field)

    {:safe, start} =
      lit_date_input(
        "#{prefix}[#{field}_between][start]",
        get_in(params, [prefix, "#{field}_between", "start"]),
        message("start")
      )

    {:safe, ending} =
      lit_date_input(
        "#{prefix}[#{field}_between][end]",
        get_in(params, [prefix, "#{field}_between", "end"]),
        message("end")
      )

    raw(start ++ ending)
  end

  def filter_date_input(prefix, field, params, :select) do
    prefix_str = to_string(prefix)
    {name, value} = find_param(params[prefix_str], field, :date)

    {:safe, date_input} =
      lit_date_input(
        "#{prefix}[#{name}]",
        value
      )

    raw(date_input)
  end

  @doc """
  Generates a filter select box for a boolean field.

  ## Example

      iex> params = %{"post" => %{"draft_equals" => "false"}}
      iex> filter_boolean_input(:post, :draft, params) |> safe_to_string()
      "<input name=\\"post[draft_equals]\\" type=\\"hidden\\" value=\\"false\\"><input class=\\"form-checkbox\\" id=\\"post_draft_equals\\" name=\\"post[draft_equals]\\" type=\\"checkbox\\" value=\\"true\\">"
  """
  def filter_boolean_input(prefix, field, params) do
    value =
      case get_in(params, [to_string(prefix), "#{field}_equals"]) do
        nil -> nil
        string when is_binary(string) -> string == "true"
      end

    checkbox(prefix, :"#{field}_equals", value: value, class: "checkbox")
  end

  defp lit_date_input(name, value) do
    tag(
      :input,
      type: "text",
      class: "input input-bordered",
      name: name,
      value: value,
      placeholder: message("Select Date")
    )
  end

  defp lit_date_input(name, value, "start") do
    tag(
      :input,
      type: "text",
      class: "input input-bordered",
      name: name,
      value: value,
      placeholder: message("Select Start Date")
    )
  end

  defp lit_date_input(name, value, "end") do
    tag(
      :input,
      type: "text",
      class: "input input-bordered",
      name: name,
      value: value,
      placeholder: message("Select End Date")
    )
  end

  defp lit_date_input(name, value, class) do
    tag(:input, type: "text", class: "input input-bordered #{class}", name: name, value: value)
  end

  defp find_param(params, pattern, type \\ :string) do
    pattern = to_string(pattern)

    result =
      Enum.find(params || %{}, fn {key, _val} ->
        String.starts_with?(key, pattern)
      end)

    cond do
      result == nil && type == :string -> {"#{pattern}_contains", nil}
      result == nil && type == :number -> {"#{pattern}_equals", nil}
      result == nil && type == :date -> {"#{pattern}_before", nil}
      result != nil -> result
    end
  end
end
