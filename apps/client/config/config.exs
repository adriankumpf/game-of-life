use Mix.Config

config :client, Client.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HWVNOOJo1m/JRjWsDsrHwI45/usVY1eGOXrrRLr8NXPErLaGYcFHvSuN+BADuB26",
  render_errors: [view: Client.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Client.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
