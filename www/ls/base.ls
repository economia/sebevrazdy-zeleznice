(err, json) <~ d3.json "../data/zeleznice.topojson"
width = window.innerWidth
height = window.innerHeight
new Map \#content json, {width, height}
    ..draw!
