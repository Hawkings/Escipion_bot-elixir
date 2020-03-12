use Mix.Config

config :escipion_bot, Escipion.Cron.Scheduler,
  jobs: [
    # Runs at 01:00 AM
    {"0 0 1 * * *",   {Escipion.Dal.Pole, :reset, [:canarian]}},
    # Runs at 12:00 PM
    {"0 0 12 * * *",  {Escipion.Dal.Pole, :reset, [:andalusian]}},
    # Runs at 23:00 AM
    {"0 0 23 * * *",  {Escipion.Dal.Pole, :reset, [:russian]}},
    # Runs every midnight:
    {"@daily",        {Escipion.Dal.Pole, :reset, [:daily]}},
    {"@daily",        {Escipion.Dal.Pole, :reset, [:random]}}
  ]

config :escipion_bot, Escipion.Cron.Scheduler,
  debug_logging: false
