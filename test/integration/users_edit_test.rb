require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael) #get from testing db, fixtures users
  end
  test "unsuccessful edit user data" do
    get login_path
    post login_path, params: {session:{email: @user.email, password: 'password'}}
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: "", email: "invalid@mail",
                                            password: "foo", password_confirmation: "foos"}}
    assert_template 'users/edit'
  end
  test "success edit user data" do
    get login_path #login first
    post login_path, params: {session: {email: @user.email, password: 'password'}}
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: "michael john", email: "michaeljohn123@gmail.com",
                                            password: "1234567", password_confirmation: "1234567"}}
    follow_redirect!
    #assert_redirected_to @user
    assert_template 'users/show' #make sure it's follow redirect to user page
    @user.reload #reload user's value from database
    assert_equal "michael john", @user.name
    assert_equal "michaeljohn123@gmail.com", @user.email
  end
end
