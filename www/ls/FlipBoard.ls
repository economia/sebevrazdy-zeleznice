window.FlipBoard = class FlipBoard
    currentDatum: null
    (@baseSelector, @animation, @data) ->
        @element = d3.select @baseSelector .append \div
            ..attr \class \flipboard
        @upperBoard = new Board do
            \upper
            @element.append \div .attr \class \upper
        @lowerBoard = new Board do
            \lower
            @element.append \div .attr \class \lower

        @animation.on \frame @~onFrame

    flip: (newDatum) ->
        for board in [@upperBoard, @lowerBoard]
            board.flip!



    onFrame: (state)->
        index = Math.floor state
        datum = @data[index]
        if datum isnt @currentDatum
            @flip datum
            @currentDatum = datum
        progress = (state % 1) * 2
        @upperBoard.progressOld progress
        @lowerBoard.progressNew progress - 1


class Board
    (@type, @element) ->
        @new = @element.append \div
            ..attr \class \new
        @old = @element.append \div
            ..attr \class \old

    progressOld: (progress) ->
        return if progress < 0
        return if progress > 1
        scale = Math.cos progress * Math.PI / 2
        @old.style \height "#{60 * scale}px"

    progressNew: (progress) ->
        return if progress < 0
        return if progress > 1
        scale = Math.sin progress * Math.PI / 2
        @new.style \height "#{60 * scale}px"

    flip: ->
        | @type == \upper => @flipNew!
        | otherwise => @flipOld!

    flipNew: ->
        @old.style \height "60px"

    flipOld: ->
        @new.style \height "0px"
