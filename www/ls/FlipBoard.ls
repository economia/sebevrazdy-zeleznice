window.FlipBoard = class FlipBoard
    @flipboardIndex = 0
    currentDatum: null
    (@baseSelector, className, header, @animation, @data) ->
        @element = d3.select @baseSelector .append \div
            ..attr \class "flipboard #{className}"
        @element.append \h2
            ..html header
        @upperBoard = new Board do
            \upper
            @element.append \div .attr \class \upper
        @lowerBoard = new Board do
            \lower
            @element.append \div .attr \class \lower

        @animation.on "frame.flip-#{@@flipboardIndex}" @~onFrame
        ++@@flipboardIndex


    onFrame: (state)->
        index = Math.floor state
        datum = @data[index]
        if datum isnt @currentDatum
            @flip datum
            @currentDatum = datum
        return if @animation.step > 8
        accellerator = Math.max do
            8 - @animation.step
            3
        progress = (state % 1) * accellerator
        [@upperBoard, @lowerBoard].forEach -> it.progress progress

    flip: (newDatum) ->
        [@upperBoard, @lowerBoard].forEach -> it.flip newDatum

class Board
    lastProgress: null
    (@type, @element) ->
        @new = @element.append \div
            ..attr \class \new
        @newContent = @new.append \span
        @old = @element.append \div
            ..attr \class \old
        @oldContent = @old.append \span

    progress: (progress) ->
        if @type == \lower
            progress -= 1
            f = Math.sin
            element = @new
        else
            f = Math.cos
            element = @old
        progress = Math.max 0, progress
        progress = Math.min 1, progress
        return if @lastProgress is progress
        @lastProgress = progress
        scale = f progress * Math.PI / 2
        if scale < 0.05 then scale = 0
        @setHeight element, scale


    flip: (value) ->
        switch @type
            | \upper    => @flipNew!
            | otherwise => @flipOld!
        @oldContent.html @newContent.html!
        @newContent.html value


    flipNew: ->
        @setHeight @old, 1

    flipOld: ->
        @setHeight @new, 0

    setHeight: (element, scale) ->
        dy = (1 - scale) * 30
        if @type == \lower then dy *= -1
        element.style "#{prefix}transform" "translate(0, #{dy}px)scaleY(#scale)"

prefix = ""
let
    for p in ["webkit", "ms", "Moz", "O"]
        if p + "Transform" of document.body.style
            prefix := "-" + p.toLowerCase() + "-"
            return
