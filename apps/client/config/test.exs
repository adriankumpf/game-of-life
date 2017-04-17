use Mix.Config

config :client, Client.Web.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn
