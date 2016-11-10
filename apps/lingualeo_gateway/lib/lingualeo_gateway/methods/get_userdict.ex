defmodule LingualeoGateway.Methods.GetUserdict do
  use Logging.Producer

  @url "http://api.lingualeo.com/userdict?port=1&offset=${offset}"

  @doc """
  Calls user's dictionary method performing
  """
  @spec call([String.t), pos_integer) :: {:ok, UserDict.t} | {:error, reason}
  def call(cookies, offset) do
    cookies_string = cookies |> Enum.join("; ")
    logging_info "Trying to get user's dictionary... Cookies are `#{cookies_string}`, offset is #{to_string(offset)}"
  end
end
