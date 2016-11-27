defmodule Storage.DB.WordTest do
  use TestCaseWithDbSandbox

  alias Storage.DB.Word

  test "for_user filters words for a given user" do
    user = :user |> create |> with_word
    collection = Word
                  |> Word.for_user(user)
                  |> Repo.all
    assert Enum.count(collection) == 1
  end

  test "with_external_id filters words by a given external ID value" do
    external_id = Faker.Internet.mac_address
    user = :user |> create |> with_word([external_id: external_id])
    collection = Word
                  |> Word.with_external_id(external_id)
                  |> Repo.all
    assert Enum.count(collection) == 1
  end
end
