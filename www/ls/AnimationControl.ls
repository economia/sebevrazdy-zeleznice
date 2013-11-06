window.AnimationControl = class AnimationControl
    (baseSelector, @animation) ->
        @element = d3.select baseSelector
        @resetButton = @element.append \button
            ..html "Přehrát od začátku"
            ..on \click ~>
                @animation.restart!

    display: ->
        @element.transition!
            ..delay 1600
            ..duration 1600
            ..style \opacity 1


