window.Tiler = class Tiler
    (parentSelector, @map) ->
        @tiles = d3.geo.tile!
            ..size [@map.width, @map.height]
            ..scale @map.zoom.scale!
            ..translate @map.zoom.translate!
        @tile = @tiles!
        @layer = @map.bgLayer
            ..attr \transform ~> "scale(#{@tile.scale})translate(#{@tile.translate})"
        @layer.selectAll \image
            .data @tile
            .enter!append \image
                ..attr \class \tile
                ..attr \width 1
                ..attr \height 1
                ..attr \xlink:href -> "http://ihned-mapy.s3-website-eu-west-1.amazonaws.com/desaturized/#{it.2}/#{it.0}/#{it.1}.png"
                ..attr \x -> it.0
                ..attr \y -> it.1
                ..on \error -> @remove!
