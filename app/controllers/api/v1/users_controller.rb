class API::V1::UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # POST /users
  # POST /users.json
  def create
    @user = User.new(name:params["name"], email_address: params["email_address"], free_credit: 0)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { 
          render json: { 
            user_details: {
              user_id: @user.id,
              user_auth_token: @user.auth_token,
              user_referral_id: @user.referral_id
            }
          }
        }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email_address, :free_credit)
    end
end
