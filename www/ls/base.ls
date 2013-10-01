(err, json) <~ d3.json "../data/zeleznice.topojson"
width = window.innerWidth
height = window.innerHeight
animation = new Animation!
    # ..start!
map = new Map do
    \#content
    json
    animation
    {width, height}
map.draw!

