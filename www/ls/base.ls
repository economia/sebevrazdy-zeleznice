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
    "Ze stanice"
    animation
    csv.map (.fromPlace)

new FlipBoard do
    \#flipboards
    \toPlace
    "Do stanice"
    animation
    csv.map (.toPlace)

new FlipBoard do
    \#flipboards
    \date
    "Datum"
    animation
    csv.map (.fromDate.format "D. M. YYYY")

new FlipBoard do
    \#flipboards
    \counter
    "Celkem incidentů"
    animation
    csv.map (.id + 1)

new FlipBoard do
    \#flipboards
    \delays
    "Celkové zpoždění"
    animation
    csv.map (.delayText)
animationControl = new AnimationControl do
    \#animationControl
    animation
window.firstStart = ->
    <~ setTimeout _, 800
    d3.select \#flipboards .transition!delay 1600 .duration 1600 .style \opacity 1
    animationControl.display!
    <~ map.fadeBg 1600
    animation.start!

overlay = d3.select \body
    ..append \div
        ..attr \class \overlay
        ..append \div
            ..html "Kliknutím spustíte vizualizaci"
        ..on \click ->
            d3.select @ .transition!
                ..duration 400
                ..style \opacity 0
                ..remove!
            firstStart!
