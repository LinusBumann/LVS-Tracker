defmodule LvsToolWeb.Router do
  use LvsToolWeb, :router

  import LvsToolWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LvsToolWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LvsToolWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", LvsToolWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:lvs_tool, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LvsToolWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", LvsToolWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{LvsToolWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", LvsToolWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{LvsToolWeb.UserAuth, :ensure_authenticated}] do
      live "/infos", InfoLive.InfoIndex, :info_index

      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/semesterentrys", SemesterentryLive.Index, :index
      live "/semesterentrys/new", SemesterentryLive.Index, :new
      live "/semesterentrys/:id/edit", SemesterentryLive.Index, :edit

      live "/semesterentrys/:id", SemesterentryLive.Show, :show
      live "/semesterentrys/:id/show/edit", SemesterentryLive.Show, :edit

      # Tab-spezifische Routen
      live "/semesterentrys/:id/standard-courses", SemesterentryLive.Show, :show_standard_courses
      live "/semesterentrys/:id/thesis", SemesterentryLive.Show, :show_thesis
      live "/semesterentrys/:id/projects", SemesterentryLive.Show, :show_projects
      live "/semesterentrys/:id/excursions", SemesterentryLive.Show, :show_excursions
      live "/semesterentrys/:id/reductions", SemesterentryLive.Show, :show_reductions

      # Standard-Kurse Modals
      live "/semesterentrys/:id/standard-courses/new",
           SemesterentryLive.Show,
           :new_standard_course

      live "/semesterentrys/:id/standard-courses/:course_id/edit",
           SemesterentryLive.Show,
           :edit_standard_course

      # Thesis Modals
      live "/semesterentrys/:id/thesis/new", SemesterentryLive.Show, :new_thesis
      live "/semesterentrys/:id/thesis/:thesis_id/edit", SemesterentryLive.Show, :edit_thesis

      # Projekte Modals
      live "/semesterentrys/:id/projects/new", SemesterentryLive.Show, :new_project
      live "/semesterentrys/:id/projects/:project_id/edit", SemesterentryLive.Show, :edit_project

      # Exkursionen Modals
      live "/semesterentrys/:id/excursions/new", SemesterentryLive.Show, :new_excursion

      live "/semesterentrys/:id/excursions/:excursion_id/edit",
           SemesterentryLive.Show,
           :edit_excursion

      # Ermäßigungen Modals
      live "/semesterentrys/:id/reductions/new", SemesterentryLive.Show, :new_reduction

      live "/semesterentrys/:id/reductions/:reduction_id/edit",
           SemesterentryLive.Show,
           :edit_reduction
    end
  end

  scope "/", LvsToolWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{LvsToolWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
