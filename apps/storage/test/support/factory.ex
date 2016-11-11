defmodule Storage.Factory do
  @moduledoc """
  Provides factory methods to build entities in tests very easy
  """

  use ExMachina.Ecto, repo: Storage.DB.Repo

  alias Storage.DB.{User, Word, WordTraining}

  def factory(:user) do
    %User{
      login: Faker.Internet.user_name
    }
  end

  def factory(:word) do
    %Word{
      value: Faker.Lorem.word
    }
  end

  def factory(:word_training) do
    %WordTraining{
      word: create(:word)
    }
  end

  def with_word(%User{} = user, opts \\ []) do
    word_opts = Keyword.merge([user: user], opts)
    create(:word, word_opts)
    user
  end

  def with_word_training(%User{} = user, opts \\ []) do
    word_training_opts = Keyword.merge([user: user], opts)
    create(:word_training, word_training_opts)
    user
  end
end
