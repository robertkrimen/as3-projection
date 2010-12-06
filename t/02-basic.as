// !tap4air
import yzzy.projection.Aperture;
// ---
var aperture:Aperture = new Aperture();
$.equal( aperture.width, 128 );
$.equal( aperture.height, 128 );
$.equal( aperture.x, 0 );
$.equal( aperture.y, 0 );
$.equal( aperture.top, -64 );
$.equal( aperture.bottom, 64 );
$.equal( aperture.left, -64 );
$.equal( aperture.right, 64 );
