defmodule Storage.DB.UserTest do
  # use ExUnit.Case, async: true
  use TestCaseWithDbSandbox

  alias Storage.DB.User

  test "signed_in? when cookies exists returns truthy value" do
    user = %User{cookies: "some"}
    assert User.signed_in?(user)
  end

  test "signed_in? when cookies are empty returns falsey value" do
    user = %User{cookies: ""}
    refute User.signed_in?(user)
  end

  test "fetch_by_login when nil is passed it returns nil" do
    assert is_nil User.fetch_by_login(nil)
  end

  test "is_in_training? returns true if user has at least one in progress training word" do
    user = create(:user) |> with_word_training(status: "in_progress")
    assert User.is_in_training?(user)
  end
end
