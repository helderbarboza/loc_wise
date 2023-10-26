defmodule LocWiseWeb.Link do
  use Phoenix.Component

  import LocWiseWeb.CoreComponents, only: [icon: 1]

  attr :icon_name, :string, required: true
  attr :rest, :global, include: ~w(navigate patch)

  def icon_button_link(assigns) do
    ~H"""
    <.link
      class="inline-flex items-center text-sm font-medium hover:bg-gray-100 dark:hover:bg-gray-700 p-1.5 dark:hover-bg-gray-800 text-center text-gray-500 hover:text-gray-800 rounded-lg focus:outline-none dark:text-gray-400 dark:hover:text-gray-100"
      type="button"
      {@rest}
    >
      <.icon name={@icon_name} class="w-5 h-5" aria-hidden="true" />
    </.link>
    """
  end
end
