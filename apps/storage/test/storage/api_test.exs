defmodule Storage.APITest do
  use TestCaseWithDbSandbox

  alias Storage.API
  alias Storage.DB.{User}

  test "user_by_login_first_or_create when a user with a given already exists just returns it" do
    user = create(:user)
    fetched_user = API.user_by_login_first_or_create(user.login)
    assert %User{} = fetched_user
    assert user.id == fetched_user.id
  end
end
