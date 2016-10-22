defmodule Storage.DB.WordTrainingTest do
  use TestCaseWithDbSandbox

  alias Storage.DB.WordTraining

  test "for_user filters word training for a given user" do
    user = create(:user) |> with_word_training
    collection = WordTraining
                  |> WordTraining.for_user(user)
                  |> Repo.all
    assert Enum.count(collection) == 1
  end

  test "with_in_progress_status filters word trainings by in_progress status" do
    create(:word_training)
    create(:word_training, status: "in_progress")
    collection = WordTraining
                  |> WordTraining.with_in_progress_status
                  |> Repo.all
    assert Enum.count(collection) == 1
  end
end
