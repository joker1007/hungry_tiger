class UnlikesController < ApplicationController

  # GET /unlikes/edit/?keycode=xxxxx
  def edit

    keycode = params[:keycode]
    @keycode = keycode
    @user = User.find_by_keycode(keycode)
    @unlike = Unlike.find_all_by_user_id(@user.id)

    @unlikes = ""
    @unlike.each {|u| @unlikes += (u.keyword + "\n")}
  end

  # editから、form経由での呼び出しを想定
  # updateに対応したviewは持たない
  def update
    
    # フラグの初期化
    okFlag = true

    # 以下、ユーザの現状のunlikeキーワード（Ａ）と
    # Formに入力されたキーワード（Ｂ）を比較し、
    # （Ａ）にのみ存在 => UnlikeのレコードをDelete
    # （Ｂ）にのみ存在 => UnlikeにレコードをCreate

    # キーワード配列（Ａ）を作成
    @user = User.find_by_keycode(params[:keycode])
    @unlike_current = Unlike.find_all_by_user_id(@user.id).map {|u| u.keyword}

    # キーワード配列（Ｂ）を作成
    @unlike_new = params[:words].split(/\r?\n/)

    # 削除用、登録用のキーワード配列を作成
    @unlike_to_del = @unlike_current - @unlike_new
    @unlike_to_add = @unlike_new - @unlike_current

    # 削除対象のレコードを削除する
    Unlike.delete_all(conditions = ["user_id = #{@user.id} AND keyword IN ('#{@unlike_to_del.join("','")}')"])

    # 作成対象のレコードを作成する
    @unlike_to_add.each do |w|
      if w.length > 0
        @one_unlike = Unlike.new(params[:unlike])
        @one_unlike.user_id = @user.id
        @one_unlike.keyword = w
        @one_unlike.save
      end
    end

    # リダイレクト用のURLを編集
    redirect_url = "/unlikes/edit/?" 
    redirect_url += "keycode=" + params[:keycode]

    # 結果メッセージの表示とリダイレクト
    flash[:notice] = "更新されました"
    redirect_to(redirect_url)
  end

end
