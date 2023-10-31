defmodule LocWiseWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  At the first glance, this module may seem daunting, but its goal is
  to provide some core building blocks in your application, such modals,
  tables, and forms. The components are mostly markup and well documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component

  import LocWiseWeb.Gettext

  alias Phoenix.HTML.Form
  alias Phoenix.HTML.FormField
  alias Phoenix.LiveView.JS

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        This is a modal.
      </.modal>

  JS commands may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.modal id="confirm" on_cancel={JS.navigate(~p"/posts")}>
        This is another modal.
      </.modal>

  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
    >
      <div id={"#{@id}-bg"} class="bg-zinc-50/90 fixed inset-0 transition-opacity" aria-hidden="true" />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
              phx-key="escape"
              phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
              class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-2xl bg-white p-14 shadow-lg ring-1 transition"
            >
              <div class="absolute top-6 right-5">
                <button
                  phx-click={JS.exec("data-cancel", to: "##{@id}")}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label={gettext("close")}
                >
                  <.icon name="x" class="h-5 w-5" />
                </button>
              </div>
              <div id={"#{@id}-content"}>
                <%= render_slot(@inner_block) %>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, default: "flash", doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class="fixed top-16 right-5 z-50 w-full max-w-xs p-4 mb-4 text-gray-500 bg-white rounded-lg shadow dark:text-gray-400 dark:bg-gray-800"
      {@rest}
    >
      <div class="flex items-center">
        <div
          :if={@kind == :info}
          class={[
            "inline-flex items-center justify-center flex-shrink-0 w-8 h-8",
            "text-emerald-500 bg-emerald-100 rounded-lg dark:bg-emerald-800 dark:text-emerald-200"
          ]}
        >
          <.icon name="info-circle" class="h-4 w-4" />
        </div>
        <div
          :if={@kind == :error}
          class={[
            "inline-flex items-center justify-center flex-shrink-0 w-8 h-8",
            "text-rose-500 bg-rose-100 rounded-lg dark:bg-rose-800 dark:text-rose-200"
          ]}
        >
          <.icon name="exclamation-circle" class="h-4 w-4" />
        </div>
        <p class="ml-3 text-sm font-normal"><%= msg %></p>
        <button
          type="button"
          class="ml-auto -mx-1.5 -my-1.5 bg-white text-gray-400 hover:text-gray-900 rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 hover:bg-gray-100 inline-flex items-center justify-center h-8 w-8 dark:text-gray-500 dark:hover:text-white dark:bg-gray-800 dark:hover:bg-gray-700"
          aria-label={gettext("close")}
        >
          <.icon name="x" class="h-5 w-5" />
        </button>
      </div>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  def flash_group(assigns) do
    ~H"""
    <.flash kind={:info} flash={@flash} />
    <.flash kind={:error} flash={@flash} />
    <.flash
      id="disconnected"
      kind={:error}
      phx-disconnected={show("#disconnected")}
      phx-connected={hide("#disconnected")}
      hidden
    >
      Attempting to reconnect
      <.icon name="refresh" class="ml-1 h-4 w-4 animate-spin" flip="horizontal" />
    </.flash>
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="mt-10 space-y-8">
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "enabled:bg-primary-700 enabled:hover:bg-primary-800 enabled:focus:ring-4",
        "enabled:focus:ring-primary-300 enabled:focus:outline-none dark:enabled:bg-primary-600",
        "dark:enabled:hover:bg-primary-700 dark:enabled:focus:ring-primary-800",
        "disabled:bg-primary-400 dark:disabled:bg-primary-500 disabled:cursor-not-allowed",
        "phx-submit-loading:opacity-75 text-white",
        "font-medium rounded-lg text-sm px-5 py-2.5 mr-2 mb-2",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `%Phoenix.HTML.Form{}` and field name may be passed to the input
  to build input names and error messages, or all the attributes and
  errors may be passed explicitly.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(autocomplete cols disabled form list max maxlength min minlength
                pattern placeholder readonly required rows size step)

  slot :inner_block

  def input(%{field: %FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox", value: value} = assigns) do
    assigns = assign_new(assigns, :checked, fn -> Form.normalize_value("checkbox", value) end)

    ~H"""
    <div phx-feedback-for={@name}>
      <div class="flex items-center">
        <input type="hidden" name={@name} value="false" />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class="rw-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
          {@rest}
        />
        <label class="ml-2 text-sm font-medium text-gray-900 dark:text-gray-300">
          <%= @label %>
        </label>
      </div>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id} class={[@errors != [] && "text-red-700 dark:text-red-500"]}>
        <%= @label %>
      </.label>
      <select
        id={@id}
        name={@name}
        class={[
          "text-sm rounded-lg block w-full p-2.5",
          "bg-gray-50 border border-gray-300 text-gray-900",
          "focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700",
          "dark:border-gray-600 dark:placeholder-gray-400 dark:text-white",
          "dark:focus:ring-blue-500 dark:focus:border-blue-500",
          "phx-no-feedback:border-gray-300 phx-no-feedback:focus:border-blue-500 phx-no-feedback:bg-gray-50 phx-no-feedback:text-gray-900",
          @errors != [] &&
            "bg-red-50 border-red-500 focus:border-red-500 text-red-900 focus:ring-red-500 dark:bg-red-100 dark:border-red-400"
        ]}
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
      </select>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <textarea
        id={@id}
        name={@name}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6",
          "phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400",
          "min-h-[6rem] border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def input(assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id} class={[@errors != [] && "text-red-700 dark:text-red-500"]}>
        <%= @label %>
      </.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "border text-sm rounded-lg block w-full p-2.5",
          "bg-gray-50 border-gray-300 text-gray-900 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500",
          "phx-no-feedback:bg-gray-50 phx-no-feedback:border-gray-300 phx-no-feedback:focus:border-blue-500 phx-no-feedback:text-gray-900 phx-no-feedback:placeholder-inherit phx-no-feedback:ring-blue-500 dark:phx-no-feedback:bg-gray-700 dark:phx-no-feedback:border-gray-600",
          @errors != [] &&
            "bg-red-50 border-red-500 focus:border-red-500 text-red-900 placeholder-red-700 focus:ring-red-500 dark:bg-red-100 dark:border-red-400"
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  attr :class, :any, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label
      for={@for}
      class={[
        "block mb-2 text-sm font-medium text-gray-900 dark:text-white phx-no-feedback:text-gray-900 dark:phx-no-feedback:text-white",
        @class
      ]}
    >
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <div class="mt-2 flex items-center gap-2 text-sm leading-6 text-red-600 dark:text-red-500 phx-no-feedback:hidden">
      <.icon name="exclamation-circle" class="h-4 w-4 flex-none" />
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <h1 class="mb-2 text-3xl font-extrabold tracking-tight text-gray-900 dark:text-white">
          <%= render_slot(@inner_block) %>
        </h1>
        <p :if={@subtitle != []} class="text-lg text-gray-500 lg:mb-0 dark:text-gray-400">
          <%= render_slot(@subtitle) %>
        </p>
      </div>
      <div class="flex-none"><%= render_slot(@actions) %></div>
    </header>
    """
  end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
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

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="overflow-y-auto relative overflow-x-auto px-4 sm:overflow-visible sm:px-0">
      <table class="w-[40rem] mt-11 sm:w-full text-sm text-left text-gray-500 dark:text-gray-400">
        <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
          <tr>
            <th :for={col <- @col} class="px-4 py-3"><%= col[:label] %></th>
            <th class="relative px-4 py-3"><span class="sr-only"><%= gettext("Actions") %></span></th>
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
            <.dynamic_tag
              :for={{col, i} <- Enum.with_index(@col)}
              name={(i == 0 && "th") || "td"}
              phx-click={@row_click && @row_click.(row)}
              class={[
                (i == 0 && "px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white") ||
                  "px-4 py-3",
                "w-full",
                @row_click && "hover:cursor-pointer"
              ]}
              {%{scope: (i == 0 && "row") || false}}
            >
              <%= render_slot(col, @row_item.(row)) %>
            </.dynamic_tag>

            <td :if={@action != []} class="px-4 py-3 flex items-center justify-end">
              <span
                :for={action <- @action}
                class="relative ml-4 font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
              >
                <%= render_slot(action, @row_item.(row)) %>
              </span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%= @post.title %></:item>
        <:item title="Views"><%= @post.views %></:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  attr :class, :string, default: nil

  def list(assigns) do
    ~H"""
    <dl class={[
      "mt-14 max-w-md text-gray-900 divide-y divide-gray-200 dark:text-white dark:divide-gray-700",
      @class
    ]}>
      <div
        :for={{item, i} <- Enum.with_index(@item, 1)}
        class={[
          "flex flex-col",
          i == 1 && "pb-3",
          i > 1 and i < length(@item) && "py-3",
          i == length(@item) && "pt-3"
        ]}
      >
        <dt class="mb-1 text-gray-500 md:text-lg dark:text-gray-400"><%= item.title %></dt>
        <dd class="text-lg font-semibold"><%= render_slot(item) %></dd>
      </div>
    </dl>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class="mt-16">
      <.link
        navigate={@navigate}
        class="text-sm flex items-center gap-2 leading-6 font-medium hover:text-gray-900 text-gray-500 dark:text-gray-400 dark:hover:text-white"
      >
        <.icon name="arrow-left" class="h-3 w-3" />
        <%= render_slot(@inner_block) %>
      </.link>
    </div>
    """
  end

  @doc """
  Renders an icons from https://tabler-icons.io/.

  ## Examples

      <.icon name="stars" class="w-3.5 h-3.5" />
  """
  attr :name, :string, required: true
  attr :set, :string, default: "tabler"
  attr :rest, :global, include: ~w(rotate inline flip)

  def icon(assigns) do
    ~H"""
    <iconify-icon icon={"#{@set}:#{@name}"} {@rest} height="unset" style="display: block">
    </iconify-icon>
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(LocWiseWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(LocWiseWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end

  @doc """
  Defines pagination opts for `Flop.Phoenix`
  """
  def pagination_opts do
    assigns = %{}
    item = "flex items-center justify-center px-3 h-8 leading-tight border"
    hover = "hover:bg-gray-100 hover:text-gray-700 dark:hover:bg-gray-700 dark:hover:text-white"

    normal =
      "text-gray-500 bg-white border-gray-300 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400"

    current =
      "text-primary-600 bg-primary-50 hover:bg-primary-100 hover:text-primary-700 dark:text-white dark:bg-gray-700 border-primary-300 dark:border-primary-700"

    [
      current_link_attrs: [
        "aria-current": "page",
        class: ["z-10", item, current, hover]
      ],
      ellipsis_attrs: [
        class: ["text-gray-400 dark:text-gray-500", item, normal]
      ],
      ellipsis_content: ~H[<span class="cursor-default">…</span>],
      previous_link_attrs: [
        class: ["order-1 rounded-l-lg -mr-px ", item, normal, hover]
      ],
      previous_link_content: ~H[<.icon name="chevron-left" class="h-4 w-4" />],
      next_link_attrs: [
        class: ["order-3 rounded-r-lg", item, normal, hover]
      ],
      next_link_content: ~H[<.icon name="chevron-right" class="h-4 w-4" />],
      disabled_class: [
        "cursor-not-allowed !text-gray-300 hover:!bg-white hover:!text-gray-300 dark:hover:!bg-gray-800 dark:!text-gray-400 dark:hover:!text-gray-400",
        item
      ],
      page_links: {:ellipsis, 3},
      pagination_link_aria_label: &"Go to page #{&1}",
      pagination_link_attrs: [
        class: [item, hover, normal]
      ],
      pagination_list_attrs: [class: "order-2 -mr-px inline-flex items-stretch -space-x-px"],
      wrapper_attrs: [class: "flex flex-nowrap w-fit"]
    ]
  end
end
