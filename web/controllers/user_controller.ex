defmodule PhoenixElixir.UserController do
    use PhoenixElixir.Web, :controller

    alias PhoenixElixir.User

    # Index function: view all users.
    def index(conn, _params) do
        users = Repo.all(User)
        render(conn, "index.html", users: users)
    end

    # Show function: view a user's profile.
    def show(conn, %{"id" => id}) do
        user = Repo.get!(User, id)
        # Users should only see, and be able to edit, their own accounts.
        cond do
            user == Guardian.Plug.current_resource(conn) ->
                render(conn, "show.html", user: user)
            :error ->
                conn
                |> put_flash(:error, "No access")
                |> redirect(to: user_path(conn, :index))
        end
    end

    # Create a new user from form.
    def new(conn, _params) do
        # Uses changeset from the User model.
        changeset = User.changeset(%User{})
        render(conn, "new.html", changeset: changeset)
    end

    # Create a new user function.
    def create(conn, %{"user" => user_params}) do
        changeset = User.reg_changeset(%User{}, user_params)

        case Repo.insert(changeset) do
            {:ok, _user} ->
                conn
                |> put_flash(:info, "User created successfully.")
                |> redirect(to: user_path(conn, :index))
            {:error, changeset} ->
                render(conn, "new.html", changeset: changeset)
        end
    end

    # Edit function.
    def edit(conn, %{"id" => id}) do
        # Pull user from database.
        user = Repo.get!(User, id)
        cond do
            user == Guardian.Plug.current_resource(conn) ->
                changeset = User.changeset(user)
                render(conn, "edit.html", user: user, changeset: changeset)
            :error ->
                conn
                |> put_flash(:error, "No access")
                |> redirect(to: user_path(conn, :index))
        end
    end

    # Update function.
    def update(conn, %{"id" => id, "user" => user_params}) do
        user = Repo.get!(User, id)
        changeset = User.reg_changeset(user, user_params)

        cond do
            user == Guardian.Plug.current_resource(conn) ->
                case Repo.update(changeset) do
                    {:ok, user} ->
                        conn
                        |> put_flash(:info, "User updated successfully.")
                        |> redirect(to: user_path(conn, :show, user))
                    {:error, changeset} ->
                        render(conn, "edit.html", user: user, changeset: changeset)
                end
            :error ->
                conn
                |> put_flash(:error, "No access")
                |> redirect(to: user_path(conn, :index))
        end
    end

    # Delete function.
    def delete(conn, %{"id" => id}) do 
        user = Repo.get!(User, id)
        cond do
            user == Guardian.Plug.current_resource(conn) ->
                Repo.delete!(user)
                conn
                |> Guardian.Plug.sign_out
                |> put_flash(:danger, "User deleted successfully")
                |> redirect(to: session_path(conn, :nwe))
            :error ->
                conn
                |> put_flash(:error, "No access")
                |> redirect(to: user_path(conn, :index))
        end
    end
end