require 'houston'
require 'gcm'
module API
  class Base < Grape::API

    format :json

    get :hello do
      { text:'hello' }
    end

    post :test do
      return {foo: "hello, #{params[:hello]}"}
    end

    # とりあえずのユーザデータ
    # users = {"aki" => 1, "obata" => 2, "banri" => 3, "moriya" => 4, "haya" => 5}
    # tokens = {
    #   "aki" => "a88b829f5cb810462640764dc599f82e80513123601f6c70a115e1ab832cc18c",
    #   "obata" => "token",
    #   "banri" => "token",
    #   "moriya" => "token",
    #   "haya" => "token"
    # }
    users = {"aki" => 1, "obata" => 2, "moriya" => 3}
    tokens = {
      "aki" => "a88b829f5cb810462640764dc599f82e80513123601f6c70a115e1ab832cc18c",
      "obata" => "f6e0504c03f3bd83a626f1c4e7fd7195ac70206197f274f4f51f28b787d59ee3",
      "moriya" => "ab1a33f9768fff4c77313d860487908036fb3eff3cb0a73828ccad9653a26f90"
    }

    tokens_android = {
      "banri" => "APA91bGw9p-hK7-36QSQyDjpggKuueORzHhKbFeMW5LbH3bWCRYwMzk-8fqXle8Q9XHIczqEiABtLBfTMmUcu-IzKel5SjAS6vHKPLvM-Iqt3KidaMvfXIn7lXaNBVh60j8n_547St9hgajQTinMqtFiSq9pdMM1dg"
    }


    # STEP1,2
    # 誘う側がサーバにリクエストをした際の動作を記述する．
    array=[]
    post :confirm do

      users.each{|key, value|
        if key != params[:inverter]

          APN = Houston::Client.development
          APN.certificate = File.read("/home/vagrant/Server/campus_de_lunch/config/server_certificates_sandbox.pem")

          notification = Houston::Notification.new(device: tokens[key])
          notification.sound = ''
          notification.alert = "Hello, World!"
          notification.content_available = true
          notification.custom_data = {inviter: params[:inverter], invitee: key, status: ""}

          APN.push(notification)
          puts "Error: #{notification.error}." if notification.error

          array.push(key)
        end
      }

      return array
    end

    #サイレントpush通知(android)
    get :silentandroid do

      api_key = "AIzaSyBzrhYXPn3w0fxbARde28W9Z8rg6FI2J_M "
      registration_ids = ["APA91bGw9p-hK7-36QSQyDjpggKuueORzHhKbFeMW5LbH3bWCRYwMzk-8fqXle8Q9XHIczqEiABtLBfTMmUcu-IzKel5SjAS6vHKPLvM-Iqt3KidaMvfXIn7lXaNBVh60j8n_547St9hgajQTinMqtFiSq9pdMM1dg "] # 送りたいregistration_idの配列
      gcm = GCM.new(api_key)
      options = {data: {message: "Hello, world", }, collapse_key: "updated_score"}
      response = gcm.send_notification(registration_ids, options)
    end


    # STEP3
    # 誘われた側が，サーバに状態を返答した際の動作を記述する．
    post :reply do
      # params[:invitee]
      # params[:status]

      # return {"return" => 1, "invitee" => "aki", "status" => true}
      # return {"invitee" => "aki", "status" => true}

      APN = Houston::Client.development
      APN.certificate = File.read("/home/vagrant/Server/campus_de_lunch/config/server_certificates_sandbox.pem")

      notification = Houston::Notification.new(device: tokens[params[:inviter]])
      notification.sound = ''
      notification.alert = "Hello, World!"
      notification.content_available = true
      notification.custom_data = {inviter: params[:inverter], invitee: params[:invitee], status: params[:status]}

      APN.push(notification)
      puts "Error: #{notification.error}." if notification.error
    end

  end
end
