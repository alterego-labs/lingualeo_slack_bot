defmodule LingualeoGateway.Methods.GetUserdictTest do
  use ExUnit.Case, async: true

  import Mock

  alias LingualeoGateway.Methods.GetUserdict
  alias LingualeoGateway.Core.{UserDict}

  @success_response_json """
  {
    "error_msg": "",
    "words": [{
      "word_id": 15211,
      "word_value": "extensive",
      "transcription": "ɪkˈstɛnsɪv",
      "training_state": 4061,
      "created_at": 1466507379,
      "last_updated_at": 1471499175,
      "sound_url": "http:\/\/audiocdn.lingualeo.com\/v2\/2\/15211-631152008.mp3",
      "word_type": 1,
      "word_top": 2,
      "word_training_timestamp": {
        "2": 0,
        "4": 0,
        "8": 0,
        "16": 0,
        "32": 0,
        "64": 0,
        "256": 0,
        "512": 0,
        "1024": 0,
        "2048": 0
      },
      "contexts": ["extensive use of infrastructure automation techniques."],
      "translate_id": 150714,
      "translate_value": "обширный",
      "pic_url": "http:\/\/contentcdn.lingualeo.com\/uploads\/picture\/269034.png",
      "word_sets": []
    }
    ],
   "next_chunk": true
  } 
  """
  @success_response %HTTPotion.Response{
    status_code: 200, body: @success_response_json,
    headers: %HTTPotion.Headers{hdrs: %{"set-cookie" => ""}}
  }

  @failure_response_401_json """
  {
    "error_msg": "",
    "error_code": 401
  }
  """

  @failure_response_401 %HTTPotion.Response{
    status_code: 200, body: @failure_response_401_json,
    headers: %HTTPotion.Headers{hdrs: %{"set-cookie" => ""}}
  }

  test "call returns UserDict struct when response is successful" do
    with_mock HTTPotion, [get: fn("http://api.lingualeo.com/userdict?port=1&offset=300", _options) ->  @success_response end] do
      result = GetUserdict.call([""], 300)
      assert {:ok, %UserDict{}} = result
    end
  end

  test "call returns proper error tuple when response is failure with 401 status code" do
    with_mock HTTPotion, [get: fn("http://api.lingualeo.com/userdict?port=1&offset=300", _options) ->  @failure_response_401 end] do
      result = GetUserdict.call([""], 300)
      assert {:error, :unauthorized} = result
    end
  end
end
