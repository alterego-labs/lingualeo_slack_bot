defmodule LingualeoGateway.HttpResponseTest do
  use ExUnit.Case, async: true

  test "from_3rd_party_response when use HTTPotion and response is failure" do
    foreign_response = %HTTPotion.Response{
      body: "{\"error_msg\":\"Email or password is incorrect\",\"error_code\":403}",
      headers: %HTTPotion.Headers{
        hdrs: %{
          "set-cookie" => ["AWSELB=asdasdsd;PATH=/;DOMAIN=lingualeo.com;HTTPONLY",
            "remember=4b960a003921a9e8a37cf4d36d93346824e3bb6ffe3da4fca3e31bcef7d7642092e02c81876a906b; expires=Mon, 16-Jan-2017 14:57:50 GMT; Max-Age=7948800; path=/; domain=lingualeo.com"]
        }
      }
    }

    normal_response = LingualeoGateway.HttpResponse.from_3rdparty_response(foreign_response)

    assert %LingualeoGateway.HttpResponse{} = normal_response
    assert normal_response.is_success == false
    assert normal_response.error_msg == "Email or password is incorrect"
  end

  test "from_3rd_party_response when use HTTPotion and response is success" do
    foreign_response = %HTTPotion.Response{
      body: "{\"error_msg\":\"\",\"daily_bonus\": 0}",
      headers: %HTTPotion.Headers{
        hdrs: %{
          "set-cookie" => ["AWSELB=asdasdsd;PATH=/;DOMAIN=lingualeo.com;HTTPONLY",
            "remember=4b960a003921a9e8a37cf4d36d93346824e3bb6ffe3da4fca3e31bcef7d7642092e02c81876a906b; expires=Mon, 16-Jan-2017 14:57:50 GMT; Max-Age=7948800; path=/; domain=lingualeo.com"]
        }
      }
    }

    normal_response = LingualeoGateway.HttpResponse.from_3rdparty_response(foreign_response)

    assert %LingualeoGateway.HttpResponse{} = normal_response
    assert normal_response.is_success == true
    assert normal_response.error_msg == ""
  end
end
