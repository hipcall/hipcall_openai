defmodule HipcallOpenai.Config do
  @moduledoc false

  defstruct api_key: nil,
            api_organization: nil,
            api_url: nil

  @api_url "https://api.openai.com/v1/"

  @spec api_url() :: any()
  def api_url, do: get_config_value(:api_url, @api_url)

  @spec api_organization() :: any()
  def api_organization,
    do: get_config_value(:api_organization, System.get_env("api_organization"))

  @spec api_key() :: any()
  def api_key, do: get_config_value(:api_key, System.get_env("api_key"))

  defp get_config_value(key, default) do
    value =
      :hipcall_openai
      |> Application.get_env(key)
      |> parse_config_value()

    if is_nil(value), do: default, else: value
  end

  defp parse_config_value({:system, env_name}), do: fetch_env!(env_name)

  defp parse_config_value({:system, :integer, env_name}) do
    env_name
    |> fetch_env!()
    |> String.to_integer()
  end

  defp parse_config_value(value), do: value

  defp fetch_env!(env_name) do
    case System.get_env(env_name) do
      nil ->
        raise ArgumentError,
          message: "could not fetch environment variable \"#{env_name}\" because it is not set"

      value ->
        value
    end
  end
end
