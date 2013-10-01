
window.Animation = class Animation
    step: 1/50
    currentValue: 0
    stopping: no
    ->
        @event = d3.dispatch "frame"
        @on = @event~on

    start: ->
        window.requestAnimationFrame @~increment

    increment: ->
        @currentValue += @step
        @event.frame @currentValue
        if not @stopping
            window.requestAnimationFrame @~increment
