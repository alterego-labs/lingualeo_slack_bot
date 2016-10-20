defmodule Storage.DB.UserTest do
  use ExUnit.Case, async: true

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
end
