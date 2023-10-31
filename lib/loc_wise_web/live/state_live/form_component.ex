defmodule LocWiseWeb.StateLive.FormComponent do
  use LocWiseWeb, :live_component

  alias LocWise.Locations

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage state records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="state-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="grid grid-cols-3 gap-4">
          <div class="col-span-2">
            <.input field={@form[:name]} type="text" label="Name" />
          </div>
          <.input field={@form[:acronym]} type="text" label="Acronym" />
        </div>
        <.input field={@form[:code]} type="number" label="Code" />
        <.input
          field={@form[:region]}
          type="select"
          label="Region"
          prompt="Choose a value"
          options={Ecto.Enum.values(LocWise.Locations.State, :region)}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save State</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{state: state} = assigns, socket) do
    changeset = Locations.change_state(state)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"state" => state_params}, socket) do
    changeset =
      socket.assigns.state
      |> Locations.change_state(state_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"state" => state_params}, socket) do
    save_state(socket, socket.assigns.action, state_params)
  end

  defp save_state(socket, :edit, state_params) do
    case Locations.update_state(socket.assigns.state, state_params) do
      {:ok, state} ->
        notify_parent({:saved, state})

        {:noreply,
         socket
         |> put_flash(:info, "State updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_state(socket, :new, state_params) do
    case Locations.create_state(state_params) do
      {:ok, state} ->
        notify_parent({:saved, state})

        {:noreply,
         socket
         |> put_flash(:info, "State created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
