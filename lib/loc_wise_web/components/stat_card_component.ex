defmodule LocWiseWeb.StatCardComponent do
  @moduledoc false

  use LocWiseWeb, :live_component

  import Number.Delimit, only: [number_to_delimited: 2]

  attr :stat, :any, required: true
  attr :icon_name, :any, required: true
  attr :number_format_opts, :list, default: [delimiter: " ", separator: ",", precision: 2]

  def(render(assigns)) do
    ~H"""
    <section class="block relative p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700 overflow-hidden">
      <.icon
        name={@icon_name}
        class="absolute h-full text-gray-500/10 dark:text-gray-500/10 right-0 top-0 translate-x-1/4 mix-blend-difference stroke-0 pointer-events-none"
      />
      <.async_result :let={stat} assign={@stat}>
        <:loading>
          <div role="status" class="max-w-sm animate-pulse mb-2">
            <div class="h-3 bg-gray-200 rounded-full dark:bg-gray-700 w-20 my-3"></div>
            <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-48 mt-8"></div>
            <span class="sr-only">Loading...</span>
          </div>
        </:loading>
        <:failed :let={_reason}>
          <.icon name="exclamation-circle" class="h-5 w-5 mb-2 text-rose-500" />
        </:failed>
        <p class="mb-2 text-3xl font-extrabold tracking-tight lowercase text-gray-900 dark:text-gray-100">
          <span class="mr-1 5"><%= number_to_delimited(stat.value, @number_format_opts) %></span>
          <span class="text-base font-normal text-gray-500 dark:text-gray-400">
            <%= stat.unit %>
          </span>
          <span :if={stat.year} class="text-xs font-normal text-gray-400 dark:text-gray-600">
            (<%= stat.year %>)
          </span>
        </p>
        <p
          class="text-lg font-medium tracking-tight truncate text-gray-500 dark:text-gray-400"
          title={stat.variable}
        >
          <%= stat.variable %>
        </p>
      </.async_result>
      <.async_result :let={stat} assign={@stat}>
        <%!-- debug --%>
        <p class="font-mono hidden">
          <%= inspect(stat) %>
        </p>
      </.async_result>
    </section>
    """
  end
end
