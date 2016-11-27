defmodule LingualeoGateway.Core.UserDictTest do
  use ExUnit.Case, async: true

  alias LingualeoGateway.HttpResponse
  alias LingualeoGateway.Core.UserDict

  test "build_from builds UserDict struct from HttpResponse" do
    words = [%{}, %{}]
    response_hash = %{
      next_chunk: true,
      words: words
    }
    http_response = %HttpResponse{response_hash: response_hash}
    user_dict = UserDict.build_from(http_response)
    assert %UserDict{} = user_dict
    assert user_dict.has_more
    assert is_list(user_dict.words)
  end
end
