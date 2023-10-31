defmodule CustomFunctions do
  defmacro lower(value) do
    quote do
      fragment("lower(?)", unquote(value))
    end
  end

  defmacro f_unaccent(value) do
    quote do
      fragment("f_unaccent(?)", unquote(value))
    end
  end
end

defmodule LocWise.FlopFilters do
  import Ecto.Query
  import CustomFunctions

  def name_and_code(q, %Flop.Filter{value: value}, _opts) do
    wildcarded = "%#{value}%"

    expr =
      dynamic(
        [f],
        ilike(lower(f_unaccent(f.name)), lower(f_unaccent(^wildcarded))) or
          ilike(f.code, ^wildcarded)
      )

    where(q, ^expr)
  end
end
