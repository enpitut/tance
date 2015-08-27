require 'houston'
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
    users = {"aki" => 1, "obata" => 2, "banri" => 3, "moriya" => 4, "haya" => 5}

    # STEP1
    # 誘う側がサーバにリクエストをした際の動作を記述する．
    array=[]
    post :confirm do
      users.each{|key, value|
        if key != params[:inverter]
          array.push(key)
        end
      }

      return array
    end

    #STEP2
    #サイレントpush通知(iOS)

    get :silentios do
      # Environment variables are automatically read, or can be overridden by any specified options. You can also
      # conveniently use `Houston::Client.development` or `Houston::Client.production`.
      APN = Houston::Client.development
      APN.certificate = File.read("/home/vagrant/Server/campus_de_lunch/config/server_certificates_sandbox.pem")
      # APN.certificate = File.read(Dir["#{Rails.root}/config/server_certificates_sandbox.pem"])

      # An example of the token sent back when a device registers for notifications
      token = "a88b829f5cb810462640764dc599f82e80513123601f6c70a115e1ab832cc18c"

      # Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
      notification = Houston::Notification.new(device: token)
      notification.alert = "Hello, World!"

      # Notifications can also change the badge count, have a custom sound, have a category identifier, indicate available Newsstand content, or pass along arbitrary data.
      notification.badge = 10000
      notification.sound = "sosumi.aiff"
      notification.category = "INVITE_CATEGORY"
      notification.content_available = true
      notification.custom_data = {foo: "bar"}

      # And... sent! That's all it takes.
      APN.push(notification)
      puts "Error: #{notification.error}." if notification.error
    end


    # STEP3
    # 誘われた側が，サーバに状態を返答した際の動作を記述する．
    post :reply do
      # params[:invitee]
      # params[:status]

      # return {"return" => 1, "invitee" => "aki", "status" => true}
      return {"invitee" => "aki", "status" => true}
    end

    # resource :memos do
    #   get do
    #     Memo.all
    #   end
    #
    #   get ':id' do
    #       Memo.find(params[:id])
    #   end
    #
    #   post do
    #     Memo.create(
    #       :title => params[:title],
    #       :body => params[:body],
    #       :author => params[:author]
    #     )
    #   end
    # end

  end
end
