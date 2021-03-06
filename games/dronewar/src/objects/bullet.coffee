class @Bullet extends Circle
  constructor: (@config = {}) ->
    super
    @is_bullet = true
    @size = 3 # bullets should be set smaller than default elements
    @fill("#000")
    
  destroy_check: (n) -> # bullet handles score value updates 
    return true if n.is_root
    @destroy()
    n.destroy()
    Gamescore.increment_value() 
    Gameprez?.score(Gamescore.value)
    true