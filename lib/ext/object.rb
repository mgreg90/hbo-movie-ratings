class Object

  def try(*args)
    send(*args)
  rescue NoMethodError
    nil
  end

end