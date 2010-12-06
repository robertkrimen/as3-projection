package yzzy.projection {

    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Aperture {

        public var point:Point = new Point( 0, 0 );
        public var rectangle:Rectangle = new Rectangle( 0, 0, NaN, NaN );
        public var dirty:Boolean = true;

        public function Aperture() {
        }

        public function get x():Number {
            return point.x;
        }

        public function set x( x_:Number ):void {
            point.x = x;
            dirty = true;
        }

        public function get y():Number {
            return point.y;
        }

        public function set y( y_:Number ):void {
            point.y = y;
            dirty = true;
        }

        public function get width():Number {
            return rectangle.width;
        }

        public function get height():Number {
            return rectangle.height;
        }

        public function get topLeft():Point {
            return rectangle.topLeft;
        }

        public function setTopLeft( x_:Number, y_:Number ):void {
            x = x_ + rectangle.width / 2;
            y = y_ + rectangle.height / 2;
            dirty = true;
        }

        public function get bottomRight():Point {
            return rectangle.bottomRight;
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

        public function translate( x_:Number, y_:Number ):void {
            point.x += x_;
            point.y += y_;
            dirty = true;
        }

        public function resize( width_:Number, height_:Number ):void {
            rectangle.width = width_;
            rectangle.height = height_;
            dirty = true;
        }

        public function update():void {
            if ( ! dirty ) return;
            rectangle.x = point.x - ( rectangle.width / 2 );
            rectangle.y = point.y - ( rectangle.height / 2 );
            dirty = false;
        }
    }
}

