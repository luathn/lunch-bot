class WebhookController < ApplicationController
  def receive
    message = params[:webhook_event][:body].sub(/\[To:4966173\]Em Thư Ký đảm đang/, '').sub(/\n/, ' ')
    room_id = params[:webhook_event][:room_id]
    url = "http://localhost:5005/webhooks/rest/webhook"
    con = Faraday.new url
    body = { "sender": "abc", "message": message }.to_json
    res = con.post "", body, "Content-Type" => "application/json"
    answer = JSON.parse(res.body).first["text"]
    ChatWork.api_key = ENV["CHATWORK_API_TOKEN"]
    ChatWork::Message.create(room_id: room_id, body: answer)
    byebug
  end
end
