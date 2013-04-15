class @Polygon extends Element # simplest path-based shape by default involving 3 straight line segments
  constructor: (@config = {}) ->
    super
    @type = 'Polygon'
    @size = @config.size || 15 # default size for polygon
    invsqrt3 = 1 / Math.sqrt(3) # to handle symmetry of the default equilateral triangle
    @path = # use an equilateral triangle as the default polygonal shape
      [
        {pathSegTypeAsLetter: 'M', x: -@size, y: @size * invsqrt3, react: true},
        {pathSegTypeAsLetter: 'L', x: 0, y: -2 * @size * invsqrt3, react: true},
        {pathSegTypeAsLetter: 'L', x: @size, y:  @size * invsqrt3, react: true},
        {pathSegTypeAsLetter: 'Z'} # close the path by default
      ]
    @path    = @config.path || @path
    @pathref = @path.map((d) -> _.clone(d)) # original path array for reference
    @polygon_path() # initialize path metadata
    @maxnode = new Vec(_.max @path, (node) -> node.d = node.x * node.x + node.y * node.y) # farthest node's coordinates define the radius of the bounding circle for the entire polygon
    @radius  = @maxnode.length()
    @pathwidth  = _.max(@path, (node) -> node.x) - _.min(@path, (node) -> node.x)
    @pathheight = _.max(@path, (node) -> node.y) - _.min(@path, (node) -> node.y)
    @image = @g.append("path") # render default polygon image 
      .attr("stroke", @_stroke)
      .attr("fill", @_fill)
      .attr("d", @d())
  
  d: -> # generate path "d" attribute
    Utils.d(@path)
    
  polygon_path: -> # assign path metadata
    for i in [0..@path.length - 1]
      continue if @path[i].pathSegTypeAsLetter == 'Z' || @path[i].pathSegTypeAsLetter == 'z'
      @path[i].r = new Vec(@path[i]).subtract(@path[i + 1 % @path.length - 1]) # vector pointing to this node from the subsequent node
      @path[i].n = new Vec({x: -@path[i].y, y: @path[i].x}).normalize() # unit normal vector 
    return
    
  rotate_path: -> # transform original path coordinates based on the angle of rotation
    for i in [0..@path.length - 1]
      seg = @path[i]
      continue unless seg.x?
      c = Math.cos(@angle)
      s = Math.sin(@angle)
      seg.x = c * @pathref[i].x - s * @pathref[i].y
      seg.y = s * @pathref[i].x + c * @pathref[i].y
    @polygon_path() 
    return
    
  set_path: (@path) -> # update path data and metadata
    @pathref = @path.map((d) -> _.clone(d)) # original path array for reference
    @polygon_path() # set path metadata
    @maxnode    = new Vec(_.max @path, (node) -> node.d = node.x * node.x + node.y * node.y) # farthest node's coordinates define the radius of the bounding circle for the entire polygon
    @radius     = @maxnode.length()
    @pathwidth  = _.max(@path, (node) -> node.x) - _.min(@path, (node) -> node.x)
    @pathheight = _.max(@path, (node) -> node.y) - _.min(@path, (node) -> node.y)
    @image.attr("d", @d())
  