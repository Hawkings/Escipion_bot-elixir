use Mix.Config

config :logger,
  backends: [:console, {LoggerFileBackend, :output_file}]

config :logger, :output_file,
  path: "logs.txt"

config :escipion_bot,
  polling_interval: 3_000

# import_config "#{Mix.env()}.exs"
import_config "telegram.secret.exs"
