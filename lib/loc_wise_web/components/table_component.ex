defmodule LocWiseWeb.TableComponent do
  use LocWiseWeb, :live_component

  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  attr :meta, Flop.Meta, required: true
  attr :target, :string, default: nil
  attr :on_change, :string, default: "update-filter"
  attr :on_paginate, :string, default: "paginate"
  attr :fields, :list, required: true
  attr :path, :any, required: true

  def render(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    assigns =
      assign(assigns,
        form: Phoenix.Component.to_form(assigns.meta),
        search_form_id: "search-#{assigns.id}"
      )

    ~H"""
    <div class="bg-white dark:bg-gray-800 relative shadow-md sm:rounded-lg overflow-hidden mt-8">
      <div class="flex flex-col md:flex-row items-center justify-between space-y-3 md:space-y-0 md:space-x-4 p-4">
        <div class="w-full md:w-1/2">
          <.form
            class="flex items-center"
            for={@form}
            id={@search_form_id}
            phx-target={@target}
            phx-change={@on_change}
            phx-submit={@on_change}
          >
            <Flop.Phoenix.filter_fields :let={i} form={@form} fields={@fields}>
              <div class="relative w-full">
                <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                  <.icon
                    aria-hidden="true"
                    class="w-5 h-5 text-gray-500 dark:text-gray-400"
                    name="search"
                  />
                </div>
                <label for={i.field.id} class="sr-only">Search</label>
                <input
                  type={i.type}
                  name={i.field.name}
                  id={i.field.id}
                  value={i.field.value}
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 p-2 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                  phx-debounce={120}
                  placeholder="Search"
                  {i.rest}
                />
              </div>
            </Flop.Phoenix.filter_fields>
          </.form>
        </div>
      </div>
      <div class="overflow-x-auto">
        <table class="w-[40rem] sm:w-full text-sm text-left text-gray-500 dark:text-gray-400">
          <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
            <tr>
              <th :for={col <- @col} class="px-4 py-3"><%= col[:label] %></th>
              <th class="relative px-4 py-3">
                <span class="sr-only"><%= gettext("Actions") %></span>
              </th>
            </tr>
          </thead>
          <tbody
            id={@id}
            phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
            class="relative divide-y divide-zinc-100 border-t border-b border-zinc-200 text-sm leading-6 text-zinc-700"
          >
            <tr
              :for={row <- @rows}
              id={@row_id && @row_id.(row)}
              class="bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-600"
            >
              <%= for {col, i} <- Enum.with_index(@col) do %>
                <%= if i == 0 do %>
                  <th
                    class={[
                      "px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white",
                      @row_click && "hover:cursor-pointer"
                    ]}
                    phx-click={@row_click && @row_click.(row)}
                    scope="row"
                  >
                    <%= render_slot(col, @row_item.(row)) %>
                  </th>
                <% else %>
                  <td
                    class={["px-4 py-3", @row_click && "hover:cursor-pointer"]}
                    phx-click={@row_click && @row_click.(row)}
                  >
                    <%= render_slot(col, @row_item.(row)) %>
                  </td>
                <% end %>
              <% end %>

              <td :if={@action != []} class="w-0 px-4 py-3 ">
                <div class="flex items-center justify-end gap-2">
                  <span
                    :for={action <- @action}
                    class="font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
                  >
                    <%= render_slot(action, @row_item.(row)) %>
                  </span>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <nav
        :if={@meta.total_count > 0}
        class="flex flex-col md:flex-row justify-between items-start md:items-center space-y-3 md:space-y-0 p-4"
        aria-label="Table navigation"
      >
        <span class="text-sm font-normal text-gray-500 dark:text-gray-400">
          Showing
          <span class="font-semibold text-gray-900 dark:text-white">
            <%= if @meta.page_size > @meta.total_count,
              do: @meta.total_count,
              else: @meta.page_size %>
          </span>
          of <span class="font-semibold text-gray-900 dark:text-white"><%= @meta.total_count %></span>
        </span>

        <Flop.Phoenix.pagination
          meta={@meta}
          on_paginate={JS.push(@on_paginate)}
          target={@target}
          path={@path}
        />
      </nav>
    </div>
    """
  end
end
