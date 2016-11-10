defmodule LingualeoGateway.Methods.GetUserdict do
  @moduledoc """
  Contains a logic to request user dictionary via LinguaLeo API
  """

  use Logging.Producer

  @url "http://api.lingualeo.com/userdict?port=1&offset=${offset}"

  @doc """
  Calls user's dictionary method performing
  """
  @spec call([String.t], pos_integer) :: {:ok, UserDict.t} | {:error, String.t}
  def call(cookies, offset) do
    cookies_string = cookies |> Enum.join("; ")
    logging_info "Trying to get user's dictionary... Cookies are `#{cookies_string}`, offset is #{to_string(offset)}"
  end
end
