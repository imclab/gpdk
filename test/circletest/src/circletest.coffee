class @Circletest extends Game
  constructor: (@config = {}) ->
    super
    @numel    = @config.numel || 64
    for i in [0..@numel - 1] # create element list
      newCircle = new TestCircle()
      @element.push(newCircle) # extend the array of all elements in this game
    for k in [0..Math.ceil(Math.sqrt(@element.length))] # place elements on grid
      for j in [0..Math.ceil(Math.sqrt(@element.length))]
        i = k * Math.floor(Math.sqrt(@element.length)) + j
        break if i > @element.length - 1
<<<<<<< HEAD:games/circletest/src/circletest.coffee
        @element[i].r.x = @width  * 0.5 + k   * (@element[i].size * 2 + @element[i].tol) - Math.ceil(Math.sqrt(@element.length)) * @element[i].size 
        @element[i].r.y = @height * 0.25 + j  * (@element[i].size  * 2 + @element[i].tol)
=======
        @element[i].r.x = Game.width  * 0.5 + k   * (@element[i].size * 2 + @element[i].tol) - Math.ceil(Math.sqrt(@element.length)) * @element[i].size 
        @element[i].r.y = Game.height * 0.25 + j  * (@element[i].size  * 2 + @element[i].tol)
>>>>>>> dev:test/circletest/src/circletest.coffee
        @element[i].draw()
    @root = new Root() # default root element i.e. under user control

  start: ->
    super
    @svg.style("cursor", "none")
    d3.select('#use_bb').on( 'click', -> Collision.use_bb = if Collision.use_bb then false else true )
    return