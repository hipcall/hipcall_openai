defmodule HipcallOpenai do
  @moduledoc """
  Documentation for `HipcallOpenai`.
  """
  alias HipcallOpenai.Config
  alias HipcallOpenai.Models

  # https://platform.openai.com/docs/api-reference/models/
  def models(config \\ %Config{}), do: Models.list(config)

  # https://platform.openai.com/docs/api-reference/models/retrieve
  def model(model, config \\ %Config{}), do: Models.retrieve(model, config)
end
