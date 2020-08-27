defmodule PhoenixElixir.Router do
  use PhoenixElixir.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.EnsureAuthenticated, handler: PhoenixElixir.Token
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Unprotected paths.
  scope "/", PhoenixElixir do
    pipe_through :browser # Use the default browser stack
    resources "/users", UserController, only: [:new, :create] 
    resources "/sessions", SessionController, only: [:create, :delete]
    get "/", SessionController, :new
  end

  # Protected paths.
  scope "/", PhoenixElixir do
    pipe_through [:browser, :browser_auth]
    resources "/users", UserController, only: [:show, :index, :update] 
    get "/chat", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixElixir do
  #   pipe_through :api
  # end
end
