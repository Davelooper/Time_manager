import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :time_manager, TimeManagerWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :time_manager, TimeManager.Repo,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  hostname: System.get_env("POSTGRES_HOST") || "db",
  database: System.get_env("POSTGRES_DB") || "time_manager_prod",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: TimeManager.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
