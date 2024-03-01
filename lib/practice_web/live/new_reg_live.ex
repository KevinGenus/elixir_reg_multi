defmodule PracticeWeb.NewRegLive do
  use PracticeWeb, :live_view

  alias Practice.Accounts
  alias Practice.Accounts.User
  alias Practice.UserProfiles
  alias Practice.UserProfiles.UserProfile

  def render(%{registration_params: _registration_params} = assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Step 2: Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
          </.link>
          Sign in
          to your account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="final_submit"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:first_name]} type="text" label="Firstname" required />
        <.input field={@form[:last_name]} type="text" label="Lastname" required />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
  
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            Sign in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="submit_registration"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    registration_changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(registration_changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("submit_registration", registration_params, socket) do
    profile_changeset = UserProfiles.change_user_profile(%UserProfile{})

    socket =
      socket
      |> assign(registration_params: registration_params)
      |> assign_form(profile_changeset)
L
    {:noreply, socket}
  end

  def handle_event("final_submit", %{"user" => profile_params}, socket) do
      IO.inspect(socket.assigns.registration_params)
      with {:ok, user} <- Accounts.register_user(socket.assigns.registration_params["user"]),
        {:ok, _user_profile} <- UserProfiles.create_user_profile(Map.put(profile_params, "user_id", user.id)) do
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )
        {:noreply, socket |> redirect(to: ~p"/")}

      else
        {:error, %Ecto.Changeset{} = changeset} ->
          IO.inspect(changeset)
          {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
    
end
