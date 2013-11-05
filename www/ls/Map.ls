window.Map = class Map
    (parentSelector, @topoData, @data, @animation, {@width, @height}:options) ->
        @projection = d3.geo.mercator!
            .scale (1 .<<. 16) / 2 / Math.PI
            .translate [@width/2, @height/2]
        center = @projection [15.48 49.82]
        @zoom = d3.behavior.zoom!
            ..scale @projection.scale! * 2 * Math.PI
            ..translate [@width - center[0], @height - center[1]]

        @projection
            ..translate [@width - center[0], @height - center[1]]

        @geoPath = d3.geo.path!
            ..projection @projection
        {@features} = topojson.feature @topoData, @topoData.objects.trate
        @features.forEach -> it.properties.trat = parseInt it.properties.trat, 10
        @svg = d3.select parentSelector .append \svg
            ..attr \width @width
            ..attr \height @height
        @bgLayer = @svg.append \g
        @railGroup = @svg.append \g

        @drawRailways!
        @animation.on \frame @~onFrame

    drawRailways: ->
        @railGroup.selectAll \path.all
            .data @features
            .enter!.append \path
                ..attr \class \all
                ..attr \d @geoPath
                ..attr \title -> it.properties.id
                ..attr \stroke \#aaa
                ..attr \stroke-width 2

    drawRailway: (railwayNumber) ->
        fadeInDuration = 800
        pauseDuration = 400
        fadeOutDuration = 800
        railwayPath = @railGroup.selectAll \path.all
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

