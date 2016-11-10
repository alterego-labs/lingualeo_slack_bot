defmodule LingualeoGateway.Core.UserDict do
  @moduledoc """
  This module provides a struct which is used as a container for a response from *userdict* API call.
  """

  @type t :: %__MODULE__{}

  defstruct has_more: false, words: []
end
