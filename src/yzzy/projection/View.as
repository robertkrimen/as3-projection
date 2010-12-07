package yzzy.projection {

    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class View {

        public var unscaledSurfaceWidth:Number = NaN;
        public var unscaledSurfaceHeight:Number = NaN;

        public var _aperture:Aperture = new Aperture();
        public var _surface:Rectangle = new Rectangle( 0, 0, NaN, NaN );
        public var _scale:Number = 1;
        public var _dirty:Boolean = true;
        public var _transform:Matrix = new Matrix();
        public var _view:Rectangle = new Rectangle( 0, 0, NaN, NaN );

        public function View( width_:Number, height_:Number, surfaceWidth_:Number, surfaceHeight_:Number ){

            _aperture.resize( width_, height_ );
            _view.width = width_;
            _view.height = height_;

            _surface.width = unscaledSurfaceWidth = surfaceWidth_;
            _surface.height = unscaledSurfaceHeight = surfaceHeight_;

            _dirty = true;
        }

        public function get width():Number {
            return _aperture.width;
        }

        public function get height():Number {
            return _aperture.height;
        }

        public function get top():Number {
            return rectangle.top;
        }

        public function get bottom():Number {
            return rectangle.bottom;
        }

        public function get left():Number {
            return rectangle.left;
        }

        public function get right():Number {
            return rectangle.right;
        }

        public function get rectangle():Rectangle {
            return _view;
        }

        public function get surface():Rectangle {
            update();
            return _surface;
        }

        public function translate ( x_:Number, y_:Number ):void {
            _aperture.translate( x_, y_ );
            _dirty = true;
        }

        public function get scale():Number {
            return _scale;
        }

        public function set scale( scale_:Number ):void {
            _aperture.update();

            var scale0:Number = _scale;
            var scale1:Number = scale_;

            _surface.width = unscaledSurfaceWidth * scale1;
            _surface.height = unscaledSurfaceHeight * scale1;

            var global0:Point = _aperture.point.clone();
            var local:Point = new Point(
                global0.x / scale0,
                global0.y / scale0
            );
            var global1:Point = new Point(
                local.x * scale1,
                local.y * scale1
            );

            translate( global1.x - global0.x, global1.y - global0.y );

            _scale = scale1;
            _dirty = true;
        }

        public function center():void {
            _aperture.setTopLeft( 0, 0 );
            translate( + 1 * _surface.width / 2, + 1 * _surface.height / 2 );
        }

        public function transformationMatrix():Matrix {
            update();
            return _transform.clone();
        }

        //private function _clamp_translation( innerLength:Number, outerLength:Number, outerLeft:Number, outerRight:Number ):Number {
        //}

        public function update():void {
            if ( ! _dirty ) return;
            _aperture.update();

            var offset:Point = _aperture.topLeft.clone();

            _surface.x = -1 * offset.x;
            _surface.y = -1 * offset.y;

            if ( width < _surface.width ) {
                if ( 0 < _surface.left ) {
                    _surface.x = 0;
                }
                else if ( _surface.right < width ) {
                    _surface.x = width - _surface.width;
                }
            }
            else {
                _surface.x = ( width - _surface.width ) / 2;
            }
            offset.x = -1 * _surface.x;

            if ( height < _surface.height ) {
                if ( 0 < _surface.top  ) {
                    _surface.y = 0;
                }
                else if ( _surface.bottom < height ) {
                    _surface.y = height - _surface.height;
                }
            }
            else {
                _surface.y = ( height - _surface.height ) / 2;
            }
            offset.y = -1 * _surface.y;

            _aperture.setTopLeft( offset.x, offset.y );
            
            _transform.identity();
            _transform.scale( _scale, _scale );
            _transform.translate( -1 * ( offset.x ), -1 * ( offset.y ) );

            _dirty = false;
        }

        public function renderBorder( filler:Function ):void {

            var context:Object = {
                view: this
            };

            if ( surface.left > left ) {
                context.left = left;
                context.top = 0;
                context.width = surface.left;
                context.height = height;
                filler.call( context );
            }

            if ( surface.right < right ) {
                context.left = surface.right;
                context.top = 0;
                context.width = width - surface.right
                context.height = height;
                filler.call( context );
            }

            if ( surface.top > top ) {
                context.left = top;
                context.top = 0;
                context.width = width;
                context.height = surface.top;
                filler.call( context );
            }

            if ( surface.bottom < bottom ) {
                context.left = 0;
                context.top = surface.bottom;
                context.width = width;
                context.height = height - surface.bottom;
                filler.call( context );
            }
        }
    }
}
