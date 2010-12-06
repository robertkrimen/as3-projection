package yzzy.projection {

    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Aperture {

        public var center:Point = new Point( 0, 0 );
        public var size:Point = new Point( 128, 128 );
        public var outline:Rectangle = new Rectangle( 0, 0, NaN, NaN );

        public function Aperture() {
            update();
        }

        public function get x():Number {
            return center.x;
        }

        public function set x( x_:Number ):void {
            center.x = x;
            update();
        }

        public function get y():Number {
            return center.y;
        }

        public function set y( y_:Number ):void {
            center.y = y;
            update();
        }

        public function get width():Number {
            return size.x;
        }

        public function get height():Number {
            return size.y;
        }

        public function get topLeft():Point {
            return outline.topLeft;
        }

        public function setTopLeft( x_:Number, y_:Number ):void {
            x = x_ + size.x / 2;
            y = y_ + size.y / 2;
        }

        public function get bottomRight():Point {
            return outline.bottomRight;
        }

        public function get top():Number {
            return outline.top;
        }

        public function get bottom():Number {
            return outline.bottom;
        }

        public function get left():Number {
            return outline.left;
        }

        public function get right():Number {
            return outline.right;
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
            outline.width = size.x;
            outline.height = size.y;
        }
    }
}

