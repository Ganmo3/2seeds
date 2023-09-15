class ChatbotsController < ApplicationController
  #csrf tokenの問題で追記コード
  protect_from_forgery

  def create
    input = params[:input]
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    # Define logic to generate response based on user input
    # https://platform.openai.com/docs/api-reference/chat/create
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # Required. # 使用するGPT-3のエンジンを指定
        messages: [{ role: "system", content: "You have the personality of a playful and independent cat, so feel free to add 'にゃん' to the end of your responses, like a cat's meow. response to japanese" },
                   { role: "user", content: input }], # Required.
        temperature: 0.7, # 応答のランダム性を指定
        max_tokens: 200,  # 応答の長さを指定
      },
    )

    respond_to do |format|
      format.json { render json: { response: response.dig("choices", 0, "message", "content") } }
    end
  end
end