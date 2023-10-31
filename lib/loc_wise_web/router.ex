defmodule LocWiseWeb.Router do
  use LocWiseWeb, :router

  import LocWiseWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LocWiseWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :internal_area do
    plug :put_area, :internal
  end

  pipeline :external_area do
    plug :put_area, :external
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LocWiseWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated, :external_area]

    get "/", PageController, :home
  end

  scope "/", LocWiseWeb do
    pipe_through [:browser, :require_authenticated_user, :internal_area]

    live_session :internal_area, on_mount: {LocWiseWeb.Area, :internal} do
      live "/overview", OverviewLive.Index, :index

      live "/states", StateLive.Index, :index
      live "/states/new", StateLive.Index, :new
      live "/states/:id/edit", StateLive.Index, :edit

      live "/states/:id", StateLive.Show, :show
      live "/states/:id/show/edit", StateLive.Show, :edit

      live "/cities", CityLive.Index, :index
      live "/cities/new", CityLive.Index, :new
      live "/cities/:id/edit", CityLive.Index, :edit

      live "/cities/:id", CityLive.Show, :show
      live "/cities/:id/show/edit", CityLive.Show, :edit

      live "/import", ImportLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", LocWiseWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:loc_wise, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LocWiseWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", LocWiseWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated, :external_area]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [
        {LocWiseWeb.UserAuth, :redirect_if_user_is_authenticated},
        {LocWiseWeb.Area, :external}
      ] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", LocWiseWeb do
    pipe_through [:browser, :require_authenticated_user, :internal_area]

    live_session :require_authenticated_user,
      on_mount: [
        {LocWiseWeb.UserAuth, :ensure_authenticated},
        {LocWiseWeb.Area, :internal}
      ] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", LocWiseWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [
        {LocWiseWeb.UserAuth, :mount_current_user},
        {LocWiseWeb.Area, :external}
      ] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
