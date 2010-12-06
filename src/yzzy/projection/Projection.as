package yzzy.projection {

    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Projection {

        public var aperture:Aperture = new Aperture();
        public var _image:Rectangle = new Rectangle( 0, 0, NaN, NaN );
        public var unscaledImageWidth:Number = NaN;
        public var unscaledImageHeight:Number = NaN;
        public var _scale:Number = 1;
        public var dirty:Boolean = true;
        public var _transform:Matrix = new Matrix();

        public function Projection ( options:Object ) {

            aperture.resize( options.screen[0], options.screen[1] );

            _image.width = unscaledImageWidth = options.image[0];
            _image.height = unscaledImageHeight = options.image[1];

            //trace( screen.width, screen.height, unscaledImageWidth, unscaledImageHeight );

            dirty = true;
        }

        public function get image ():Rectangle {
            update();
            return _image;
        }

        public function translate ( x_:Number, y_:Number ):void {

            aperture.translate( x_, y_ );

            dirty = true;
        }

        public function get scale ():Number {
            return _scale;
        }

        public function set scale ( scale_:Number ):void {

            _image.width = unscaledImageWidth * scale_;
            _image.height = unscaledImageHeight * scale_;

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
            translate( +1 * _image.width / 2, +1 * _image.height / 2 );
        }

        public function transformationMatrix():Matrix {
            update();
            return _transform.clone();
        }

        public function update ():void {

            if ( ! dirty ) return;

            var halfImage:Point = new Point( _image.width / 2, _image.height / 2 );
            var halfAperture:Point = new Point( aperture.width / 2, aperture.height / 2 );
            var offset:Point = new Point( 0, 0 );
            var screen:Rectangle = aperture.outline.clone();

            offset.x = ( aperture.x - halfAperture.x );
            offset.y = ( aperture.y - halfAperture.y );

            trace( 'offset', offset.x, offset.y );
            _image.x = -1 * offset.x;
            _image.y = -1 * offset.y;

            trace( _image, 'right', _image.right, 'bottom', _image.bottom,
                screen, 'right', screen.right, 'bottom', screen.bottom );

            if ( screen.width < _image.width ) {
                if ( 0 < _image.left ) {
                    _image.x = 0;
                }
                else if ( _image.right < screen.width ) {
                    _image.x = screen.width - _image.width;
                }
            }
            else {
                _image.x = halfAperture.x - halfImage.x;
            }
            offset.x = -1 * _image.x;

            if ( screen.height < _image.height ) {
                if ( 0 < _image.top  ) {
                    _image.y = 0;
                }
                else if ( _image.bottom < screen.height ) {
                    _image.y = screen.height - _image.height;
                }
            }
            else {
                _image.y = halfAperture.y - halfImage.y;
            }
            offset.y = -1 * _image.y;

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
