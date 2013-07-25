class @Paddle extends Polygon
  constructor: (@config = {}) ->
    super
    @is_root   = true # Make this the player controlled element
    @fixed     = true    
    @size      = 90
    @angleStep = 2 * Math.PI / 60 # initialize per-step angle change magnitude 
    @stroke("#700")
    @fill("red")
    # Use default paddle if none defined

    @path = @config.path || [
             {pathSegTypeAsLetter: 'M', x: -150,  y: -5, react: true},
             {pathSegTypeAsLetter: 'L', x: -150,  y: 5, react: true},
             {pathSegTypeAsLetter: 'L', x: 150,  y: 5, react: true},
             {pathSegTypeAsLetter: 'L', x: 150,  y: -5, react: true},
             {pathSegTypeAsLetter: 'Z'}
             ]    
    @image.attr("stroke", @_stroke)
    @image.attr("fill", @_fill)
    @react = true
    @charge = 5e4 
    @set_path()
    @r.x       = @width / 2
    @r.y       = @height - @bb_height * 0.5
    

  redraw: (xy = d3.mouse(@svg.node())) =>
    return unless @react # don't draw if not active
    @r.x = xy[0]
    @r.y = xy[1]
    @draw()
    @collision_detect()


  start: ->
    super
    # @svg.on("mousemove", @redraw) # default mouse behavior is to control the root element position
    
  
    
  stop: ->
    super
    @svg.on("mousemove", null) # default mouse behavior is to control the root element position
    

  death_check: (n) ->
    n.death()
    @death()
    Gamescore.lives -= 1 # decrement lives for this game
  
  death: ->
    N    = 240 # random color parameter
    fill = '#ff0' 
    dur  = 120 # color effect transition duration parameter
    @image # default reaction
      .transition()
      .duration(dur)
      .ease('sqrt')
      .attr("fill", fill)
      .transition()
      .duration(dur)
      .ease('linear')
      .attr("fill", @fill())
  