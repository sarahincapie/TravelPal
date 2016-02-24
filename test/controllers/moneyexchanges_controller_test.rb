require 'test_helper'

class MoneyexchangesControllerTest < ActionController::TestCase
  setup do
    @moneyexchange = moneyexchanges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:moneyexchanges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create moneyexchange" do
    assert_difference('Moneyexchange.count') do
      post :create, moneyexchange: { money: @moneyexchange.money }
    end

    assert_redirected_to moneyexchange_path(assigns(:moneyexchange))
  end

  test "should show moneyexchange" do
    get :show, id: @moneyexchange
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @moneyexchange
    assert_response :success
  end

  test "should update moneyexchange" do
    patch :update, id: @moneyexchange, moneyexchange: { money: @moneyexchange.money }
    assert_redirected_to moneyexchange_path(assigns(:moneyexchange))
  end

  test "should destroy moneyexchange" do
    assert_difference('Moneyexchange.count', -1) do
      delete :destroy, id: @moneyexchange
    end

    assert_redirected_to moneyexchanges_path
  end
end
