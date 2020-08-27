# PhoenixElixir

Ran:

- `mix phoenix.new phoenix_elixir`
- (y to install deps), which runs
    - mix deps.get 
    - npm install && node_modules/brunch/bin/brunch build
- `cd phoenix_elixir && mix ecto.create` (config for Postgres in `config/dev.exs`)
- `mix phoenix.server`

Changes:

Setting up the basic chat app (w/o authentication)

- `web/templates/page/index.html.exs`
  - removed content
  - replaced with messaging server html
- ran `mix phoenix.gen.presence`
  - ^ creates `web/channls/presence.ex`
- Adds module to supervision tree (`lib/phoenix_elixir.ex`):
  - appends `supervisor(PhoenixElixir.Presence, []),` to children
  - This tracks users as they log in and out of server
- Create websocket in Phoenix app (`web/channels/user_socket.ex)
  - an open connection between client and application/server
  - Uncomment line5: `  channel "room:*", PhoenixElixir.RoomChannel`
  - update `connect` function (line 22):
    ```
      def connect(%{"user" => user}, socket) do
        {:ok, assign(socket, :user, user)}
      end
    ```
- New file: `web/channels/room_channel.ex`
- Edit: `web/static/js/app.js`
- Users messaging each other: 
  - edit `web/channels/room_channel.ex`
  - edit `web/static/js/app.js`
- Minor style updates to `web/templates/page/index.html.exs`

Adding authentication

- get database working `config/dev.exs`
  - `mix phoenix.gen.model User users email:unique encrypt_pass:string` -> built in scaffolding tool.
    ```
    * creating web/models/user.ex
    * creating test/models/user_test.exs
    * creating priv/repo/migrations/20200826195455_create_user.exs

    Remember to update your repository by running migrations:

        $ mix ecto.migrate
    ```
  - mix ecto.migrate
  - Creating a user
    ```
    iex -S mix phoenix.server
    alias PhoenixElixir.Repo
    alias PhoenixElixir.User
    Repo.all(User)
    Repo.insert(%User{email: "test@test.com", encrypt_pass: "password"})
    ```

    result:
    ```
    [debug] QUERY OK db=2.4ms
    INSERT INTO "users" ("email","encrypt_pass","inserted_at","updated_at") VALUES ($1,$2,$3,$4) RETURNING "id" ["test@test.com", "password", {{2020, 8, 26}, {20, 5, 1, 0}}, {{2020, 8, 26}, {20, 5, 1, 0}}]
    {:ok,
    %PhoenixElixir.User{
      __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
      email: "test@test.com",
      encrypt_pass: "password",
      id: 1,
      inserted_at: #Ecto.DateTime<2020-08-26 20:05:01>,
      password: nil,
      updated_at: #Ecto.DateTime<2020-08-26 20:05:01>
    }}
    ```
  - add `web/controllers/user_controller.ex`
  - add `web/views/user_view.ex`
  - add  line to `router.ex` -> `    resources "/users", UserController`
  - new file: `web/templates/user/index.html.eex`
  - Viewing available routes:
      ```
      $ mix phoenix.routes
      warning: found quoted keyword "test" but the quotes are not required. Note that keywords are always atoms, even when quoted. Similar to atoms, keywords made exclusively of Unicode letters, numbers, underscore, and @ do not require quotes
        mix.exs:52

      user_path  GET     /users           PhoenixElixir.UserController :index
      user_path  GET     /users/:id/edit  PhoenixElixir.UserController :edit
      user_path  GET     /users/new       PhoenixElixir.UserController :new
      user_path  GET     /users/:id       PhoenixElixir.UserController :show
      user_path  POST    /users           PhoenixElixir.UserController :create
      user_path  PATCH   /users/:id       PhoenixElixir.UserController :update
                PUT     /users/:id       PhoenixElixir.UserController :update
      user_path  DELETE  /users/:id       PhoenixElixir.UserController :delete
      page_path  GET     /                PhoenixElixir.PageController :index
      ```

Come on in:

- ```
  iex -S mix phoenix.server
  Comeonin.Pbkdf2.hashpwsalt("password")
  ```

Guardian
  ```
  mix phoenix.gen.secret
  ```

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
