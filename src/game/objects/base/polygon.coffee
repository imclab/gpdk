class @Polygon extends Element # simplest path-based shape by default involving 3 straight line segments
  constructor: (@config = {}) ->
    super(@config)
    @type = 'Polygon'
    @path  = @config.path || @default_path() # use an equilateral triangle as the default polygonal shape
    @image = @g.append("path") # render default polygon image   
    @fill(@_fill)
    @stroke(@_stroke)
    @set_path()
  
  default_path: ->
    invsqrt3 = 1 / Math.sqrt(3) # to handle symmetry of the default equilateral triangle
    [
      {pathSegTypeAsLetter: 'M', x: -@size, y: @size * invsqrt3, react: true},
      {pathSegTypeAsLetter: 'L', x: 0,      y: -2 * @size * invsqrt3, react: true},
      {pathSegTypeAsLetter: 'L', x: @size,  y: @size * invsqrt3, react: true},
      {pathSegTypeAsLetter: 'Z'} # close the path by default
    ]

  d: -> # generate path "d" attribute
    Utils.d(@path)
    
  polygon_path: -> # assign path metadata
    for i in [0..@path.length - 2] # set edge vectors: path.r
      @path[i].r = new Vec(@path[i]).subtract(@path[(i + 1) % (@path.length - 1)]) # vector pointing to this node from the subsequent node
      @path[i].n = new Vec({x: -@path[i].r.y, y: @path[i].r.x}).normalize() # unit normal vector 
    @BB()
    return

  set_path: (@path = @path) -> # update path data and metadata
    @pathref  = @path.map((d) -> _.clone(d)) # original path array for reference
    @polygon_path() # set path metadata
    @maxnode  = new Vec(_.max @path, (node) -> node.d = node.x * node.x + node.y * node.y) # farthest node's coordinates define the radius of the bounding circle for the entire polygon
    @size     = @maxnode.length()
    @image.attr("d", @d())
  
  BB: ->
    @bb_width  = _.max(@path, (node) -> node.x).x - _.min(@path, (node) -> node.x).x
    @bb_height = _.max(@path, (node) -> node.y).y - _.min(@path, (node) -> node.y).y
    super
    
  rotate_path: -> # transform original path coordinates based on the angle of rotation
    for i in [0..@path.length - 1]
      seg = @path[i]
      continue unless seg.x?
      c = Math.cos(@angle)
      s = Math.sin(@angle)
      seg.x = c * @pathref[i].x - s * @pathref[i].y
      seg.y = s * @pathref[i].x + c * @pathref[i].y
    @polygon_path() # don't call set_path here to avoid overwriting @pathref
    return