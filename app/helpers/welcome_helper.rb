module WelcomeHelper

  def attributes_for(object, *args)
    object.dig(*args)
  end

end
