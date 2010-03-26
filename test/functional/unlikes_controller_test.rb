require 'test_helper'

class UnlikesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:unlikes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create unlike" do
    assert_difference('Unlike.count') do
      post :create, :unlike => { }
    end

    assert_redirected_to unlike_path(assigns(:unlike))
  end

  test "should show unlike" do
    get :show, :id => unlikes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => unlikes(:one).to_param
    assert_response :success
  end

  test "should update unlike" do
    put :update, :id => unlikes(:one).to_param, :unlike => { }
    assert_redirected_to unlike_path(assigns(:unlike))
  end

  test "should destroy unlike" do
    assert_difference('Unlike.count', -1) do
      delete :destroy, :id => unlikes(:one).to_param
    end

    assert_redirected_to unlikes_path
  end
end
