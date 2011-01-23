# yzzy.projection.View - Calculate a pan/zoom transformation matrix

## SYNOPSIS

    import yzzy.projection.View

    ...

    var view:View = new View( 
        viewport.width, viewport.height,
        image.width, image.height
    );

    // Center viewport with image
    view.center();

    view.translate( 240, 100 );
    view.scale = 1.6;

    var transform:Matrix = view.transformationMatrix();

    // Begin the rendering on the panned and zoomed result:
    var graphics:Graphics = viewport.graphics;
    graphics.clear()
    graphics.beginBitmapFill( bitmapData, transform, false, true );
    graphics.drawRect( 0, 0, view.width, view.height );
    graphics.endFill();

    // Cover up any "exposed" border as a result of zooming out
    view.renderBorder( function():void {
        graphics.beginFill( 0xaaaaaa );
        graphics.drawRect( this.left, this.top, this.width, this.height );
    } );


## DESCRIPTION

yzzy.projection.View is a tool for calculating the transformation matrix (flash.geom.Matrix) when panning and zooming around an image

## AUTHOR

Robert Krimen &lt;robertkrimen@gmail.com&gt;

## COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Robert Krimen.

This is free software; you can redistribute it and/or modify it under the same
terms as the Perl 5 programming language system.
