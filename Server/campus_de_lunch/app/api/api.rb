require 'houston'
require 'gcm'
module API
  class Base < Grape::API
    format :json

    tokens = {
      "aki" => "a88b829f5cb810462640764dc599f82e80513123601f6c70a115e1ab832cc18c",
      "obata" => "f6e0504c03f3bd83a626f1c4e7fd7195ac70206197f274f4f51f28b787d59ee3",
      "moriya" => "ab1a33f9768fff4c77313d860487908036fb3eff3cb0a73828ccad9653a26f90",
      "haya" => "bed730095bf1f99ae7060c8d21326e716815dadf184bbd4c0670075d1a65cde7",
      "banri" => "APA91bGw9p-hK7-36QSQyDjpggKuueORzHhKbFeMW5LbH3bWCRYwMzk-8fqXle8Q9XHIczqEiABtLBfTMmUcu-IzKel5SjAS6vHKPLvM-Iqt3KidaMvfXIn7lXaNBVh60j8n_547St9hgajQTinMqtFiSq9pdMM1dg"
    }

    # STEP1,2
    # 誘う側がサーバにリクエストをした際の動作を記述する．
    array=[]
    post :confirm do
      tokens.each{|key, value|
        if key != params[:inviter]
          if key != "banri"
            APN = Houston::Client.development
            APN.certificate = File.read("/home/vagrant/Server/campus_de_lunch/config/server_certificates_sandbox.pem")

            notification = Houston::Notification.new(device: tokens[key])
            notification.sound = ''
            notification.alert = "STEP2: Detected Confirm. FROM: #{params[:inviter]} TO: #{key}"
            notification.content_available = true
            notification.custom_data = {inviter: params[:inviter], invitee: key, status: ''}

            APN.push(notification)
            puts "Error: #{notification.error}." if notification.error

            array.push(key)

          else
            api_key = "AIzaSyBzrhYXPn3w0fxbARde28W9Z8rg6FI2J_M"
            registration_ids = ["APA91bGw9p-hK7-36QSQyDjpggKuueORzHhKbFeMW5LbH3bWCRYwMzk-8fqXle8Q9XHIczqEiABtLBfTMmUcu-IzKel5SjAS6vHKPLvM-Iqt3KidaMvfXIn7lXaNBVh60j8n_547St9hgajQTinMqtFiSq9pdMM1dg"] # 送りたいregistration_idの配列
            gcm = GCM.new(api_key)
            options = {data: {inviter: params[:inviter], invitee: key, status: ''}, collapse_key: "updated_score"}
            response = gcm.send_notification(registration_ids, options)
            array.push(key)
          end

        end
      }

      return array
    end


    # STEP3,4
    # 誘われた側が，サーバに状態を返答した際の動作を記述する．
    post :reply do
      if params[:inviter] != "banri"

        APN = Houston::Client.development
        APN.certificate = File.read("/home/vagrant/Server/campus_de_lunch/config/server_certificates_sandbox.pem")

        notification = Houston::Notification.new(device: tokens[params[:inviter]])
        notification.sound = ''
        notification.alert = "STEP4: Detected Reply. FROM: #{params[:inviter]} TO: #{params[:invitee]}"
        notification.content_available = true
        notification.custom_data = {inviter: params[:inviter], invitee: params[:invitee], status: params[:status]}

        APN.push(notification)
        puts "Error: #{notification.error}." if notification.error

      else
        api_key = "AIzaSyBzrhYXPn3w0fxbARde28W9Z8rg6FI2J_M"
        registration_ids = ["APA91bGw9p-hK7-36QSQyDjpggKuueORzHhKbFeMW5LbH3bWCRYwMzk-8fqXle8Q9XHIczqEiABtLBfTMmUcu-IzKel5SjAS6vHKPLvM-Iqt3KidaMvfXIn7lXaNBVh60j8n_547St9hgajQTinMqtFiSq9pdMM1dg"] # 送りたいregistration_idの配列
        gcm = GCM.new(api_key)
        options = {data: {inviter: params[:invirter], invitee: params[:invitee], status: params[:status]}, collapse_key: "updated_score"}
        response = gcm.send_notification(registration_ids, options)
      end
    end

  end
end
