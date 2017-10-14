defmodule SlackClone.Repo do
  use Ecto.Repo, otp_app: :slack_clone
  use Scrivener, page_size: 25
end
