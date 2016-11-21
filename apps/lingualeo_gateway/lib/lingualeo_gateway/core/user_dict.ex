defmodule LingualeoGateway.Core.UserDict do
  @moduledoc """
  This module provides a struct which is used as a container for a response from *userdict* API call.
  """

  defstruct has_more: false, words: []

  @type t :: %__MODULE__{}

  alias LingualeoGateway.HttpResponse

  @doc """
  Builds user dictionary struct from a HttpResponse
  """
  @spec build_from(HttpResponse.t) :: __MODULE__.t
  def build_from(%HttpResponse{} = http_response) do
    response_hash = http_response.response_hash
    %__MODULE__{
      has_more: Map.get(response_hash, :has_more),
      words: Map.get(response_hash, :words)
    }  
  end
end
