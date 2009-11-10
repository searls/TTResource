require 'test_helper'

class DogsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dogs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dog" do
    assert_difference('Dog.count') do
      post :create, :dog => { }
    end

    assert_redirected_to dog_path(assigns(:dog))
  end

  test "should show dog" do
    get :show, :id => dogs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => dogs(:one).to_param
    assert_response :success
  end

  test "should update dog" do
    put :update, :id => dogs(:one).to_param, :dog => { }
    assert_redirected_to dog_path(assigns(:dog))
  end

  test "should destroy dog" do
    assert_difference('Dog.count', -1) do
      delete :destroy, :id => dogs(:one).to_param
    end

    assert_redirected_to dogs_path
  end
end
