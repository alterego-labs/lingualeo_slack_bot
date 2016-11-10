defmodule Storage.DB.WordTrainingTest do
  use TestCaseWithDbSandbox

  alias Storage.DB.WordTraining

  test "for_user filters word training for a given user" do
    user = :user |> create |> with_word_training
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

  test "build_new_for builds word training struct based on word struct" do
    user = create(:user) 
    word = create(:word, user: user)
    word_training = WordTraining.build_new_for(word)
    assert %WordTraining{} = word_training
    assert word_training.status == "in_progress"
    assert word_training.user != nil
    assert word_training.word != nil
  end
end
