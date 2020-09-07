defmodule TranscoderrWeb.PageView do
  use TranscoderrWeb, :view

  @empty ""

  def capitalize_text(atom) when is_atom(atom) do
    to_string(atom) |> capitalize_text()
  end

  def capitalize_text(text) when is_binary(text) do
    String.capitalize(text)
  end

  def has_menu_items?(%{items: _}) do
    true
  end

  def has_menu_items?(_) do
    false
  end

  def is_active?(%{active: true}) do
    "active"
  end

  def is_active?(_), do: @empty
end
