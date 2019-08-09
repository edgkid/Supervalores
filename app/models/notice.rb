class Notice
  def initialize(title, message, type=:info, force=false)
    @title = title
    @message = message
    @type = type
  end

  def title
    @title
  end

  def message
    @message
  end

  def type
    @type
  end

  def force
    @force
  end
end