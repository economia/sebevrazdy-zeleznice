(err, json) <~ d3.json "../data/trate.topo.json"
delaySum = 0
(err, csv) <~ d3.csv do
    "../data/incidenty.csv"
    (it, index) ->
        [fromPlace, toPlace] = it.name.split " - "
        fromDate = moment it.start, "YYYYMMDDHHmmss"
        toDate   = moment it.end, "YYYYMMDDHHmmss"

        delay = (+toDate.format "X") - (+fromDate.format "X")
        delaySum += delay
        delayText = switch
        | delaySum < 3600 * 4 => "#{Math.round delaySum / 3600} hodiny"
        | delaySum < 3600 * 24 * 3 => "#{Math.round delaySum / 3600} hodin"
        | delaySum < 3600 * 24 * 5 => "#{Math.round delaySum / 3600 / 24} dny"
        | otherwise => "#{Math.round delaySum / 3600 / 24} dnů"
        return do
            id        : index
            railway   : parseInt it.id, 10
            fromPlace : fromPlace
            toPlace   : toPlace
            fromDate  : fromDate
            toDate    : toDate
            delaySum  : delaySum
            delayText : delayText

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

new FlipBoard do
    \#flipboards
    \fromPlace
    animation
    csv.map (.fromPlace)

new FlipBoard do
    \#flipboards
    \toPlace
    animation
    csv.map (.toPlace)

new FlipBoard do
    \#flipboards
    \date
    animation
    csv.map (.fromDate.format "D. M. YYYY")

new FlipBoard do
    \#flipboards
    \counter
    animation
    csv.map (.id + 1)

new FlipBoard do
    \#flipboards
    \delays
    animation
    csv.map (.delayText)

# <~ setTimeout _, 800
<~ map.fadeBg 100
animation.start!
