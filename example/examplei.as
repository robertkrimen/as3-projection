import yzzy.projection.Projection;

import mx.core.FlexGlobals;
import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.system.fscommand;
import mx.core.Application;
import mx.core.UIComponent;
import mx.controls.Image;
import mx.controls.Button;
import mx.containers.HBox;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.geom.Point;
import flash.display.Shape;
import flash.display.Graphics;
import flash.events.*;
import flash.utils.Timer;
import spark.components.Application;
import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.collections.*;
import mx.core.UIComponent;
import mx.controls.Image;

[Embed(source="image.jpg")]
[Bindable]
public var $imageSource:Class;

private var $bitmapData:BitmapData = new $imageSource().bitmapData;
private var $scale:Number = 1;
private var $scaledSize:Point = new Point( NaN, NaN );
private var $offset:Point = new Point( 0, 0 );

private var $camera:Point = new Point( 0, 0 );
private var $image:Rectangle = new Rectangle( 0, 0, $bitmapData.width, $bitmapData.height );

private var $mousePosition:Point = new Point( NaN, NaN );
private var $mouseDelta:Point = new Point( 0, 0 );

private var $mouseOffStage:Boolean = false;

private var projection:Projection;

private function onMouseMove( $event:MouseEvent ):void {

    if ( !$event.buttonDown ) {
        return;
    }

    $mouseDelta.x = mouseX - $mousePosition.x;
    $mouseDelta.y = mouseY - $mousePosition.y;

    translate( -1 * $mouseDelta.x, -1 * $mouseDelta.y );

    $mousePosition.x = mouseX;
    $mousePosition.y = mouseY;

    invalidateDisplayList();
}

private function onMouseDown( $event:MouseEvent ):void {
    $mousePosition.x = mouseX;
    $mousePosition.y = mouseY;
    $mouseOffStage = false;

    addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
    stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
    stage.addEventListener( Event.MOUSE_LEAVE, onMouseLeave );
    stage.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
    stage.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );

}

private function onMouseOver( $event:MouseEvent ):void {
    $mouseOffStage = false;
}

private function onMouseOut( $event:MouseEvent ):void {
    $mouseOffStage = true;
}

private function onMouseLeave( $event:Event ):void {
    if ( $mouseOffStage ) {
        removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
    }
}

private function onMouseUp( $event:MouseEvent ):void {
    removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
}

private function translate( $x:Number, $y:Number ):void {

    projection.translate( $x, $y );
    invalidateDisplayList();
}

private function scale( $newScale:Number ):void {

    projection.scale = $newScale;
    invalidateDisplayList();

}

public function render():void {

    if ( ! projection ) {
        return;
    }

    var transform:Matrix = projection.transformationMatrix();

    var graphics:Graphics = viewport.graphics;
    graphics.clear()
    graphics.beginBitmapFill( $bitmapData, transform, 
        false, // tile
        true // smooth bitmap
    );
    graphics.drawRect( 0, 0, projection.aperture.width, projection.aperture.height );
    graphics.endFill();

    var color:Number = 0xaaaaaa;

    if ( projection.surface.left > projection.view.left ) {
        graphics.beginFill( color );
        graphics.drawRect( projection.view.left, 0, projection.surface.left, projection.aperture.height );
    }

    if ( projection.surface.right < projection.aperture.width ) {
        graphics.beginFill( color );
        graphics.drawRect( projection.surface.right, 0, projection.aperture.width - projection.surface.right, projection.aperture.height );
    }

    if ( projection.surface.top > projection.view.top ) {
        graphics.beginFill( color );
        graphics.drawRect( projection.view.top, 0, projection.aperture.width, projection.surface.top );
    }

    if ( projection.surface.bottom < projection.aperture.height ) {
        graphics.beginFill( color );
        graphics.drawRect( 0, projection.surface.bottom, projection.aperture.width, projection.aperture.height -  projection.surface.bottom );
    }
}

override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void {
    super.updateDisplayList( unscaledWidth, unscaledHeight );
    render();
}

public function creationComplete():void {

    projection = new Projection(
        viewport.width, viewport.height,
        $bitmapData.width, $bitmapData.height
    );

    projection.center();

    FlexGlobals.topLevelApplication.addEventListener( KeyboardEvent.KEY_DOWN, function( $event:KeyboardEvent ):void {

        var $change:Boolean = true;
        var $multiplier:Number = 1;
        if ( $event.shiftKey ) $multiplier *= 10;
        if ( $event.ctrlKey ) $multiplier *= 10;

        switch ( $event.keyCode )  {
            case flash.ui.Keyboard.UP: $offset.y -= 1 * $multiplier; $change = true; break;
            case flash.ui.Keyboard.DOWN: $offset.y += 1 * $multiplier; $change = true; break;
            case flash.ui.Keyboard.LEFT: $offset.x -= 1 * $multiplier; $change = true; break;
            case flash.ui.Keyboard.RIGHT: $offset.x += 1 * $multiplier; $change = true; break;
        }

        if ( $change ) {
            invalidateDisplayList();
        }

    } );

    viewport.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
    viewport.addEventListener( MouseEvent.MOUSE_UP, onMouseUp )
		
    invalidateDisplayList();
}
