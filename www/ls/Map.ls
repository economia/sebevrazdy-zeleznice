window.Map = class Map
    currentDatum: null
    dataLength: null
    (parentSelector, @topoData, @data, @animation, {@width, @height}:options) ->
        @dataLength = @data.length
        @projection = d3.geo.mercator!
            .scale 50000  / 2 / Math.PI
            .translate [@width/2, @height/2]
        center = @projection [15.48 49.90]
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
        @bgFaderGroup = @svg.append \g
        @bgFader = @bgFaderGroup.append \rect
            ..attr \x 0
            ..attr \y 0
            ..attr \width @width
            ..attr \height @height
            ..attr \fill \black
            ..attr \opacity 0

        @railGroup = @svg.append \g
        @drawRailways!
        @animation.on \frame.map @~onFrame

    fadeBg: (duration, cb) ->
        @bgFader.transition!
            ..duration duration
            ..attr \opacity 0.8
        <~ setTimeout _, duration
        @railways.transition!
            ..duration duration
            ..attr \opacity 1
        setTimeout cb, duration

    drawRailways: ->
        @railways = @railGroup.selectAll \path.all
            .data @features
            .enter!.append \path
                ..attr \class \all
                ..attr \d @geoPath
                ..attr \title -> it.properties.id
                ..attr \stroke \#666
                ..attr \stroke-width 2
                ..attr \opacity 0

    drawRailway: (railwayNumber, isLast) ->
        glowDuration = 100
        fadeInDuration = 200
        pauseDuration = 600
        fadeOutDuration = 800
        railwayPath = @railways.filter -> it.properties.trat == railwayNumber
        railwayPath
            ..transition!
                ..duration glowDuration
                ..attr \stroke \#ee0
            ..transition!
                ..delay glowDuration
                ..duration fadeInDuration
                ..attr \stroke \#fff
        if not isLast
            railwayPath.transition!
                ..delay pauseDuration + fadeInDuration + glowDuration
                ..duration fadeOutDuration
                ..attr \stroke \#666

    onFrame: (state) ->
        dataIndex = Math.floor state
        datum = @data[dataIndex]
        if datum is void
            @animation.stop!
            return
        if datum isnt @currentDatum
            @drawRailway datum.railway, dataIndex == @dataLength - 1
            @currentDatum = datum

