class UnlikesController < ApplicationController
  # GET /unlikes
  # GET /unlikes.xml
  def index
    @unlikes = Unlike.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @unlikes }
    end
  end

  # GET /unlikes/1
  # GET /unlikes/1.xml
  def show
    @unlike = Unlike.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @unlike }
    end
  end

  # GET /unlikes/new
  # GET /unlikes/new.xml
  def new
    @unlike = Unlike.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @unlike }
    end
  end

  # GET /unlikes/edit/?keycode=xxxxx
  def edit
    # メッセージエリアの編集
    if params[:message]
      @message = "<div><font size=\"5\" color=\"red\">" + params[:message] + "</font></div>"
    else
      @message = ""
    end

    keycode = params[:keycode]
    @keycode = keycode
    @user = User.find_by_keycode(keycode)
    @unlike = Unlike.find_all_by_user_id(@user.id)

    @unlikes = ""
    @unlike.each {|u| @unlikes += (u.keyword + "\n")}
  end

  # POST /unlikes
  # POST /unlikes.xml
  def create
    @unlike = Unlike.new(params[:unlike])

    respond_to do |format|
      if @unlike.save
        flash[:notice] = 'Unlike was successfully created.'
        format.html { redirect_to(@unlike) }
        format.xml  { render :xml => @unlike, :status => :created, :location => @unlike }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @unlike.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /unlikes/1
  # PUT /unlikes/1.xml
  def update
    okFlag = true
    @user = User.find_by_keycode(params[:keycode])

    if okFlag = true
      flash[:notice] = '更新されました'
      redirect_url = "/unlikes/edit/?" 
      redirect_url += "keycode=" + params[:keycode]
      redirect_to(redirect_url)
    else
      render :action => "edit"
      render :xml => @unlike.errors, :status => :unprocessable_entity
    end
  end

  # DELETE /unlikes/1
  # DELETE /unlikes/1.xml
  def destroy
    @unlike = Unlike.find(params[:id])
    @unlike.destroy

    respond_to do |format|
      format.html { redirect_to(unlikes_url) }
      format.xml  { head :ok }
    end
  end
end
