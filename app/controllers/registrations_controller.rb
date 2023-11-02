class RegistrationsController < Devise::RegistrationsController

  protected

  def after_sign_up_path_for(resource)
    if current_user.host?
      :new_inn 
    else
      :root
    end
  end
end