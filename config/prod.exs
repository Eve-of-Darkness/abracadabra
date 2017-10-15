use Mix.Config

config :abracadabra, Abracadabra.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "abracadabra_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool_size: 10
