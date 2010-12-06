package yzzy.projection {

    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Projection {

        public var aperture:Aperture = new Aperture();
        public var _surface:Rectangle = new Rectangle( 0, 0, NaN, NaN );
        public var unscaledSurfaceWidth:Number = NaN;
        public var unscaledSurfaceHeight:Number = NaN;
        public var _scale:Number = 1;
        public var dirty:Boolean = true;
        public var _transform:Matrix = new Matrix();
        public var _view:Rectangle = new Rectangle( 0, 0, NaN, NaN );

        public function Projection( width_:Number, height_:Number, surfaceWidth_:Number, surfaceHeight_:Number ){

            aperture.resize( width_, height_ );
            this._view.width = width_;
            this._view.height = height_;

            _surface.width = unscaledSurfaceWidth = surfaceWidth_;
            _surface.height = unscaledSurfaceHeight = surfaceHeight_;

            dirty = true;
        }


        public function get width():Number {
            return this.aperture.width;
        }

        public function get height():Number {
            return this.aperture.height;
        }

        public function get view():Rectangle {
            return this._view;
        }

        public function get surface ():Rectangle {
            update();
            return _surface;
        }

        public function translate ( x_:Number, y_:Number ):void {

            aperture.translate( x_, y_ );

            dirty = true;
        }

        public function get scale ():Number {
            return _scale;
        }

        public function set scale ( scale_:Number ):void {

            _surface.width = unscaledSurfaceWidth * scale_;
            _surface.height = unscaledSurfaceHeight * scale_;

            var global0:Point = aperture.center.clone();
            var local:Point = new Point(
                global0.x / _scale,
                global0.y / _scale
            );
            var global1:Point = new Point(
                local.x * scale_,
                local.y * scale_
            );

            translate( global1.x - global0.x, global1.y - global0.y );
            _scale = scale_;

            dirty = true;
        }

        public function center ():void {
            aperture.x = 0;
            aperture.y = 0;
            translate( +1 * _surface.width / 2, +1 * _surface.height / 2 );
        }

        public function transformationMatrix():Matrix {
            update();
            return _transform.clone();
        }

        public function update ():void {

            if ( ! dirty ) return;

            var halfSurface:Point = new Point( _surface.width / 2, _surface.height / 2 );
            var halfAperture:Point = new Point( aperture.width / 2, aperture.height / 2 );
            var offset:Point = new Point( 0, 0 );
            var screen:Rectangle = aperture.outline.clone();

            offset.x = ( aperture.x - halfAperture.x );
            offset.y = ( aperture.y - halfAperture.y );

            trace( 'offset', offset.x, offset.y );
            _surface.x = -1 * offset.x;
            _surface.y = -1 * offset.y;

            trace( _surface, 'right', _surface.right, 'bottom', _surface.bottom,
                screen, 'right', screen.right, 'bottom', screen.bottom );

            if ( screen.width < _surface.width ) {
                if ( 0 < _surface.left ) {
                    _surface.x = 0;
                }
                else if ( _surface.right < screen.width ) {
                    _surface.x = screen.width - _surface.width;
                }
            }
            else {
                _surface.x = halfAperture.x - halfSurface.x;
            }
            offset.x = -1 * _surface.x;

            if ( screen.height < _surface.height ) {
                if ( 0 < _surface.top  ) {
                    _surface.y = 0;
                }
                else if ( _surface.bottom < screen.height ) {
                    _surface.y = screen.height - _surface.height;
                }
            }
            else {
                _surface.y = halfAperture.y - halfSurface.y;
            }
            offset.y = -1 * _surface.y;

            aperture.x = ( offset.x +halfAperture.x );
            aperture.y = ( offset.y +halfAperture.y );
            
            trace( 'aperture', aperture.x, aperture.y, 'scale', _scale );

            _transform.identity();
            _transform.scale( _scale, _scale );
            _transform.translate( -1 * ( offset.x ), -1 * ( offset.y ) );

            dirty = false;
        }
    }
}
