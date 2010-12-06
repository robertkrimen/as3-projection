package yzzy.projection {

    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Aperture {

        public var center:Point = new Point( 0, 0 );
        public var size:Point = new Point( 128, 128 );
        public var outline:Rectangle = new Rectangle( 0, 0, NaN, NaN );

        public function get width():Number {
            return size.x;
        }

        public function get height():Number {
            return size.y;
        }

        public function Aperture() {
            update();
        }

        public function translate( x_:Number, y_:Number ):void {
            center.x += x_;
            center.y += y_;
            update();
        }

        public function resize( width_:Number, height_:Number ):void {
            size.x = width_;
            size.y = height_;
            update();
        }

        public function update():void {
            outline.x = center.x - ( size.x / 2 );
            outline.y = center.y - ( size.y / 2 );
        }
    }
}

