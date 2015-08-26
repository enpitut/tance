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
