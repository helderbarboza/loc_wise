defmodule LocWiseWeb.ContentTypography do
  @moduledoc """
  Typography components for content pages.
  """

  use Phoenix.Component

  attr :rest, :global
  slot :inner_block, required: true

  def p(assigns) do
    ~H"""
    <p class="mb-4 text-gray-500 dark:text-gray-400" {@rest}><%= render_slot(@inner_block) %></p>
    """
  end

  attr :rest, :global
  slot :inner_block, required: true

  def h1(assigns) do
    ~H"""
    <h1 class="mb-4 text-3xl font-extrabold text-gray-900 dark:text-white tracking-tight" {@rest}>
      <%= render_slot(@inner_block) %>
    </h1>
    """
  end

  attr :rest, :global
  slot :inner_block, required: true

  def h2(assigns) do
    ~H"""
    <h2
      class="mb-4 mt-2 text-2xl font-semibold leading-loose text-gray-900 dark:text-white tracking-tight"
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </h2>
    """
  end
end
