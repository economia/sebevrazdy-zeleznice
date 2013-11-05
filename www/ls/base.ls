(err, json) <~ d3.json "../data/trate.topo.json"
(err, csv) <~ d3.csv do
    "../data/incidenty.csv"
    (it, index) ->
        [fromPlace, toPlace] = it.name.split " - "
        return do
            id        : index
            railway   : parseInt it.id, 10
            fromPlace : fromPlace
            toPlace   : toPlace
            fromDate  : moment it.start, "YYYYMMDDHHmmss"
            toDate    : moment it.end, "YYYYMMDDHHmmss"

width = window.innerWidth
height = window.innerHeight
animation = new Animation!

map = new Map do
    \#content
    json
    csv
    animation
    {width, height}
tiler = new Tiler do
    \#content
    map

flipBoard = new FlipBoard do
    \#content
    animation
    csv.map (.fromPlace)

# <~ setTimeout _, 800
<~ map.fadeBg 100
animation.start!
