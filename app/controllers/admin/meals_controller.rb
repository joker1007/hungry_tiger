class Admin::MealsController < ApplicationController
  # GET /admin_meals
  # GET /admin_meals.xml
  def index

    @week = params[:week].to_i

    # パラメータを初期化
    if !params[:week]
      weekShift = 0
    else
      weekShift = @week
    end

    # 食事リストを作成
    @fromDate = Date.today + weekShift * 7 - Date.today.wday
    @meals = []
    for i in 0..6 # 0:日曜日～6：土曜日
      # 朝食をリストに追加
      if i != 0
        if !(aMeal = Meal.find(:first, :conditions => ["meal_type = 'Breakfast' AND date = '#{@fromDate + i}'"]))
          aMeal = Meal.new()
          aMeal.date = @fromDate + i
          aMeal.name = "朝食"
        end
        @meals.push(aMeal)
      end

      # 夕食をリストに追加
      if i != 6
        if !(aMeal = Meal.find(:first, :conditions => ["meal_type = 'Dinner' AND date = '#{@fromDate + i}'"]))
          aMeal = Meal.new()
          aMeal.date = @fromDate + i
          aMeal.name = ""
        end
        @meals.push(aMeal)
      end
    end

    # 次週、先週のリンクを作成
    @prevWeek = ""
    if weekShift > 0
      @prevWeek += "<a href=\"/admin/meals/?week=#{weekShift - 1}\">"
      @prevWeek += "< 前の週</a>"
    end
    #
    @nextWeek = "<a href=\"/admin/meals/?week=#{weekShift + 1}\">"
    @nextWeek += "次の週 ></a>"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_meals }
    end
  end

  # PUT /admin_meals/1
  # PUT /admin_meals/1.xml
  def update

    # 送信されてきた各日のメニューについて追加・変更・削除処理
    for i in 0..6

      # 処理対象の日付を計算
      cur_date = Date.strptime(params[:fromDate], "%Y-%m-%d") + i

      # 入力に応じてMealテーブルを更新・追加
      if (tMeal = Meal.find(:first, :conditions => ["meal_type = 'Dinner' AND date = '#{cur_date}'"]))
      # 該当日付のレコードが存在する場合、名前を変更
        tMeal.name = params["d#{i}"]
        tMeal.save
      else
      # 該当日付のレコードが存在しない場合、新規作成
        aMeal = Meal.new()
        aMeal.date = cur_date
        aMeal.meal_type = "Dinner"
        aMeal.name = params["d#{i}"]
        aMeal.save
      end
      # 該当日付の朝食レコードが存在しない場合、新規作成
      if !(tMeal = Meal.find(:first, :conditions => ["meal_type = 'Breakfast' AND date = '#{cur_date}'"]))
        aMeal = Meal.new()
        aMeal.date = cur_date
        aMeal.meal_type = "Breakfast"
        aMeal.name = "朝食"
        aMeal.save
      end
    end

    # リダイレクト用のURLを編集
    redirect_url = "/admin/meals/?week=" 
    redirect_url += params[:week]

    # 結果メッセージの表示とリダイレクト
    flash[:notice] = "更新完了"
    redirect_to(redirect_url)
  end

end
