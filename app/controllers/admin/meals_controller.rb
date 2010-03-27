class MealsController < ApplicationController
  # GET /admin_meals
  # GET /admin_meals.xml
  def index
    @admin_meals = Meal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_meals }
    end
  end

  # GET /admin_meals/1
  # GET /admin_meals/1.xml
  def show
    @meal = Meal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @meal }
    end
  end

  # GET /admin_meals/new
  # GET /admin_meals/new.xml
  def new
    @meal = Meal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @meal }
    end
  end

  # GET /admin_meals/1/edit
  def edit
    @meal = Meal.find(params[:id])
  end

  # POST /admin_meals
  # POST /admin_meals.xml
  def create
    @meal = Meal.new(params[:meal])

    respond_to do |format|
      if @meal.save
        flash[:notice] = 'Meal was successfully created.'
        format.html { redirect_to(@meal) }
        format.xml  { render :xml => @meal, :status => :created, :location => @meal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @meal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_meals/1
  # PUT /admin_meals/1.xml
  def update
    @meal = Meal.find(params[:id])

    respond_to do |format|
      if @meal.update_attributes(params[:meal])
        flash[:notice] = 'Meal was successfully updated.'
        format.html { redirect_to(@meal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @meal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_meals/1
  # DELETE /admin_meals/1.xml
  def destroy
    @meal = Meal.find(params[:id])
    @meal.destroy

    respond_to do |format|
      format.html { redirect_to(admin_meals_url) }
      format.xml  { head :ok }
    end
  end
end
