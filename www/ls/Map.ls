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
        @svg = d3.select parentSelector .append \svg
            ..attr \width width
            ..attr \height height
        @path = @svg.append \path

        @animation.on \frame @~onFrame

    drawRailways: (indices) ->
        console.log indices
        railways = indices.map ~> @features[it]
        console.log railways
        @svg.selectAll \path
            .data @features
            .enter!.append \path
                ..attr \d @geoPath
                ..attr \title -> it.properties.id

    onFrame: (state) ->
        dataIndex = Math.floor state
        datum = @data[dataIndex]
        railwayIndices = datum.railways.map -> it - 1
        @drawRailways railwayIndices


getCount = (datastring) ->
    count = 0
    lines = datastring.split "\n"
    sum = lines.reduce  do
        (sum, line) ->
            num = line.split '\t' .pop!
            sum += parseInt num
        0
