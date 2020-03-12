use Mix.Config

config :logger,
  backends: [:console, {LoggerFileBackend, :output_file}]

config :logger, :output_file, path: "logs.txt"

import_config "cron.exs"
import_config "#{Mix.env()}.exs"
