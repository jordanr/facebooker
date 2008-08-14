require File.dirname(__FILE__) + '/test_helper.rb' 
require 'action_controller'
require 'active_support'
require 'facebooker/rails/controller'
require 'facebooker/rails/test_helpers'

module TestHelperTestCases
  def test_get
    facebook_get :index
    assert_response :success
  end

  def test_post
    facebook_post :index
    assert_response :success
  end

  def test_put
    facebook_put :index
    assert_response :success
  end

  def test_delete
    facebook_delete :index
    assert_response :success
  end

  def test_assert_redirect_to
    facebook_get :redirect_to_index
    assert_facebook_redirect_to "/facebook_app_name/#{Inflector.underscore(@controller.class)}"
    assert_facebook_redirect_to "facebook_app_name/#{Inflector.underscore(@controller.class)}"
    assert_facebook_redirect_to "http://apps.facebook.com/facebook_app_name/#{Inflector.underscore(@controller.class)}"
    # TODO:
      # assert_facebook_redirect_to :action=>'index'
  end
end

class FacebookTestController < ActionController::Base
  include Facebooker::Rails::Controller
  def rescue_action(e) raise e end

  def index
    render :text=>"hello index"
  end

  def redirect_to_index
    redirect_to :action=> 'index'
  end
end

class TestHelpersTestForAuthenticatedControllers < Test::Unit::TestCase
  include Facebooker::Rails::TestHelpers, TestHelperTestCases

  class FacebookControllerThatRequiresAuthentication < FacebookTestController
    ensure_authenticated_to_facebook
  end

  def setup
    @controller = FacebookControllerThatRequiresAuthentication.new
    @response = ActionController::TestResponse.new
    @request = ActionController::TestRequest.new
  end

end

class TestHelpersTestForNonAuthenticatedControllers < Test::Unit::TestCase
  include Facebooker::Rails::TestHelpers, TestHelperTestCases

  class FacebookControllerThatDoesNotRequireAuthentication < FacebookTestController
  end

  def setup
    @controller = FacebookControllerThatDoesNotRequireAuthentication.new
    @response = ActionController::TestResponse.new
    @request = ActionController::TestRequest.new
  end
end

