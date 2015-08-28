require 'houston'
module API
  class Base < Grape::API
    format :json


    # users = {"aki" => 1, "obata" => 2, "moriya" => 3, "haya" => 4}
    tokens = {
      "aki" => "a88b829f5cb810462640764dc599f82e80513123601f6c70a115e1ab832cc18c",
      "obata" => "f6e0504c03f3bd83a626f1c4e7fd7195ac70206197f274f4f51f28b787d59ee3",
      "moriya" => "ab1a33f9768fff4c77313d860487908036fb3eff3cb0a73828ccad9653a26f90",
      "haya" => "bed730095bf1f99ae7060c8d21326e716815dadf184bbd4c0670075d1a65cde7"
    }
    # users = {aki: 1, obata: 2, moriya: 3, haya: 4}
    # tokens = {
    #   aki: "a88b829f5cb810462640764dc599f82e80513123601f6c70a115e1ab832cc18c",
    #   obata: "f6e0504c03f3bd83a626f1c4e7fd7195ac70206197f274f4f51f28b787d59ee3",
    #   moriya: "ab1a33f9768fff4c77313d860487908036fb3eff3cb0a73828ccad9653a26f90",
    #   haya: "bed730095bf1f99ae7060c8d21326e716815dadf184bbd4c0670075d1a65cde7"
    # }


    # STEP1,2
    # 誘う側がサーバにリクエストをした際の動作を記述する．
    array=[]
    post :confirm do
      tokens.each{|key, value|
        if key != params[:inviter]

          APN = Houston::Client.development
          APN.certificate = File.read("/home/vagrant/Server/campus_de_lunch/config/server_certificates_sandbox.pem")

          notification = Houston::Notification.new(device: tokens[key])
          notification.sound = ''
          # notification.alert = "Hello, World!"
          notification.content_available = true
          notification.custom_data = {inviter: params[:inverter], invitee: key, status: ''}

          APN.push(notification)
          puts "Error: #{notification.error}." if notification.error

          array.push(key)
        end
      }
      return array
    end


    # STEP3
    # 誘われた側が，サーバに状態を返答した際の動作を記述する．
    post :reply do

      APN = Houston::Client.development
      APN.certificate = File.read("/home/vagrant/Server/campus_de_lunch/config/server_certificates_sandbox.pem")

      notification = Houston::Notification.new(device: tokens[params[:inviter]])
      notification.sound = ''
      # notification.alert = "Hello, World!"
      notification.content_available = true
      notification.custom_data = {inviter: params[:inverter], invitee: params[:invitee], status: params[:status]}

      APN.push(notification)
      puts "Error: #{notification.error}." if notification.error

      # return params[:invitee]
    end

  end
end
