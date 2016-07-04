require 'test_helper'

class FabricsControllerTest < ActionController::TestCase
  setup do
    @fabric = fabrics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fabrics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fabric" do
    assert_difference('Fabric.count') do
      post :create, fabric: { color: @fabric.color, image_url: @fabric.image_url, type: @fabric.type }
    end

    assert_redirected_to fabric_path(assigns(:fabric))
  end

  test "should show fabric" do
    get :show, id: @fabric
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fabric
    assert_response :success
  end

  test "should update fabric" do
    patch :update, id: @fabric, fabric: { color: @fabric.color, image_url: @fabric.image_url, type: @fabric.type }
    assert_redirected_to fabric_path(assigns(:fabric))
  end

  test "should destroy fabric" do
    assert_difference('Fabric.count', -1) do
      delete :destroy, id: @fabric
    end

    assert_redirected_to fabrics_path
  end
end
