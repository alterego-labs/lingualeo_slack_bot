defmodule TestHelper do
  def valid_raw_word do
    %{
      word_id: "123",
      word_value: "привет",
      translation: "hello",
      transcription: "hello",
      sound_url: "http://some.com/123",
      pic_url: "http://some.com/124"
    }
  end

  def valid_income_message do
    %SlackBot.Core.IncomeMessage{
      message: %{
        channel: "channel_id",
        team: "team_id",
        text: "hi!",
        ts: "1476706205.000002",
        type: "message",
        user: "user_id"
      },
      slack: %{
        users: %{
          "user_id" => %{
            id: "user_id",
            is_admin: false,
            profile: %{
              email: "some@gmail.com"
            },
            name: "sergeg1990"
          }
        }
      }
    }
    
  end
end


ExUnit.start()
