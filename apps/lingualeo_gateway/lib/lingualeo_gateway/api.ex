defmodule LingualeoGateway.API do
  @moduledoc """
  Provides exposed methods to request LinguaLeo API.

  So you must use methods from this module, instead using ones from `LingualeoGateway.ApiPoint`
  module.
  """

  @type status_message :: String.t
  @type response_hash  :: Map.t
  @type cookies :: [String.t]
  @type reason :: Atom.t

  @doc """
  Performs sign in request.

  The result contains the whole needed information to perform further actions:
  
    - overall status: success or failure response
    - status message: when failure it contains error message
    - response hash
    - cookies array
  """
  @spec sign_in(String.t, String.t) :: {:ok | :error, status_message, response_hash, cookies}
  def sign_in(email, password) do
    LingualeoGateway.ApiPoint.sign_in(email, password)  
  end

  @doc """
  Makes a request to get user dictionary.

  A session is resolved by a bunch of cookies from the sign in response.
  Also *userdict* Lingualeo API method returns only 400 words in maximum, but you can paginate them
  by passing offset value.
  """
  @spec get_userdict(list(String.t), pos_integer) :: {:ok, UserDict.t} | {:error, reason}
  def get_userdict(cookies, offset \\ 400) do
    LingualeoGateway.ApiPoint.get_userdict(cookies, offset)  
  end
end
