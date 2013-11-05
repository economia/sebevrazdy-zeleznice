window.Map = class Map
    (parentSelector, @topoData, @data, @animation, {width, height}:options) ->
        scaleX = 8.45 * width
        scaleY = 14.7 * height
        scale = Math.min scaleX, scaleY
        @projection = d3.geo.mercator!
            .center [15.48 49.82]
            .scale scale
            .translate [width/2 height/2]

        @geoPath = d3.geo.path!
            ..projection @projection
        {@features} = topojson.feature @topoData, @topoData.objects.trate
        @features.forEach -> it.properties.trat = parseInt it.properties.trat, 10
        @svg = d3.select parentSelector .append \svg
            ..attr \width width
            ..attr \height height

        @drawRailways!
        @animation.on \frame @~onFrame

    drawRailways: ->
        @svg.selectAll \path.all
            .data @features
            .enter!.append \path
                ..attr \class \all
                ..attr \d @geoPath
                ..attr \title -> it.properties.id
                ..attr \stroke \#aaa

    drawRailway: (railwayNumber) ->
        fadeInDuration = 800
        pauseDuration = 400
        fadeOutDuration = 800
        railwayPath = @svg.selectAll \path.all
            .filter -> it.properties.trat == railwayNumber
        railwayPath
            ..transition!
                ..duration fadeInDuration
                ..attr \stroke \#f00
            ..transition!
                ..delay fadeInDuration + pauseDuration
                ..duration fadeOutDuration
                ..attr \stroke \#aaa

    onFrame: (state) ->
        dataIndex = Math.floor state
        datum = @data[dataIndex]
        @drawRailway datum.railway

getCount = (datastring) ->
    count = 0
    lines = datastring.split "\n"
    sum = lines.reduce  do
        (sum, line) ->
            num = line.split '\t' .pop!
            sum += parseInt num
        0
