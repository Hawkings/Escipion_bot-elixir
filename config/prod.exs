use Mix.Config

config :escipion_bot,
  polling_interval: 3_000

import_config "prod.telegram.secret.exs"
