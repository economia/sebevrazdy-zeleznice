window.Map = class Map
    (parentSelector, @topojson, {width, height}:options) ->
        scaleX = 8.45 * width
        scaleY = 14.7 * height
        scale = Math.min scaleX, scaleY
        @projection = d3.geo.mercator!
            .center [15.48 49.82]
            .scale scale
            .translate [width/2 height/2]

        @svg = d3.select parentSelector .append \svg
            ..attr \width width
            ..attr \height height

    draw: ->
        geoPath = d3.geo.path!
            ..projection @projection
        {features} = topojson.feature @topojson, @topojson.objects.zeleznice
        sums = {}
        max = -Infinity

        @svg.selectAll \path
            .data features
            .enter!.append \path
                ..attr \d geoPath

getCount = (datastring) ->
    count = 0
    lines = datastring.split "\n"
    sum = lines.reduce  do
        (sum, line) ->
            num = line.split '\t' .pop!
            sum += parseInt num
        0
