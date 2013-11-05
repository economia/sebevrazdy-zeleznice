(err, json) <~ d3.json "../data/zeleznice.topojson"
(err, csv) <~ d3.tsv do
    "../data/skokani.csv"
    (it, index) ->
        [fromPlace, toPlace] = it.nazev.split " - "
        return do
            id        : index
            railways  : it.id.split "," .map -> parseInt it, 10
            fromPlace : fromPlace
            toPlace   : toPlace
            fromDate  : moment it.od, "DD.MM.YYYY HH:mm"
            toDate    : moment it.do, "DD.MM.YYYY HH:mm"

width = window.innerWidth
height = window.innerHeight
animation = new Animation!
    # ..start!
map = new Map do
    \#content
    json
    csv
    animation
    {width, height}

map.onFrame 21

