package rayTriangle;
import rayTriangle.Ray;
import rayTriangle.Vec3;
class PerfTest {
    public static inline
    var NUM_RAYS = 100;
    public static inline
    var NUM_TRIANGLES: Int = Std.int( 1000 * 1000 );
    public inline
    function rayTriangleIntersect( r: Ray, v0: Vec3, v1: Vec3, v2: Vec3 ): Float {
        var v0v2 = ( v2 - v0 );
        var pvec = r.dir % v0v2;
        var v0v1 = ( v1 - v0 );
        var det =  v0v1.dot( pvec );
        return if( det < 0.000001 ){
            Math.NEGATIVE_INFINITY;
        } else {
            var invDet = 1./det;
            var tvec = r.orig - v0;
            var u = tvec.dot( pvec ) * invDet;
            if( u < 0 || u > 1 ) {
                Math.NEGATIVE_INFINITY;
            } else {
                var qvec = tvec % v0v1;
                var v = r.dir.dot( qvec ) * invDet;
                if (v < 0 || u + v > 1){ 
                    Math.NEGATIVE_INFINITY;
                } else {
                    v0v2.dot( qvec ) * invDet;
                }
            }
        }
    }
    public static inline
    function rndPlusMinus(): Float {
        return Math.random() * 2. - 1.;
    }
    public inline
    function randomVertex(): Vec3 {
        return new Vec3( { x: rndPlusMinus()
                         , y: rndPlusMinus()
                         , z: rndPlusMinus()  } );
    }
    public inline 
    function generateRandomTriangles( numTriangles: Int ): Array<Vec3> {
        var vertices = new Array<Vec3>();
        var j: Int;
        for( i in 0...numTriangles ){
            j = i*3;
            vertices[ j + 0 ] = randomVertex();
            vertices[ j + 1 ] = randomVertex();
            vertices[ j + 2 ] = randomVertex();
        }
        return vertices;
    }
    public inline
    function randomSphere(): Vec3 {
        var lat = Math.acos( rndPlusMinus() ) - ( Math.PI/2 );
        var lon = ( Math.PI/2 * Math.random() );
        return new Vec3( { x: Math.cos( lat ) * Math.cos( lon )
                         , y: Math.cos( lat ) * Math.sin( lon )
                         , z: Math.sin( lat )
                     } );
    }
    public static function main(){ new PerfTest(); }
    public function new(){
        var vertices = generateRandomTriangles( NUM_TRIANGLES );
        var numVectices = Std.int( NUM_TRIANGLES * 3 );
        var r: Ray = { orig: Vec3.zero()
                     , dir:  Vec3.zero() };
        var t: Float = 0.;
        var k: Float;
        var numHit  = 0;
        var numMiss = 0;
        var tStart = haxe.Timer.stamp();
        for( i in 0...NUM_RAYS ){
            r.orig = randomSphere();
            r.dir =  ( randomSphere() - r.orig ).normalize();
            for( j in 0...NUM_TRIANGLES ){
                k = Std.int( j * 3 );
                t = rayTriangleIntersect( r
                                        , vertices[ Std.int( k + 0 ) ]
                                        , vertices[ Std.int( k + 1 ) ]
                                        , vertices[ Std.int( k + 2 ) ] );
            }
            ( t >= 0 )? ++numHit: ++numMiss;
        }
        var tEnd = haxe.Timer.stamp();
        var tTotal = (tEnd - tStart);
        var tTotal2 = floatToStringPrecision( tTotal, 2 );
        var numTests = Std.int( NUM_RAYS * NUM_TRIANGLES );
        var hitPerc  = floatToStringPrecision( ( numHit / numTests ) * 100.0, 2 );
        var missPerc = floatToStringPrecision( ( numMiss / numTests ) * 100.0, 2 );
        var mTestsPerSecond = floatToStringPrecision( numTests / tTotal / 1000000, 2 );
        
        trace( '\n' + 
               'Total intersection tests: $numTests \n'    +
               '  Hits:\t\t\t   $numHit ( $hitPerc ) \n'   +
               '  Misses:\t\t   $numMiss ( $missPerc ) \n' +
               '  Total time:\t\t\t  $tTotal2 seconds \n' +
               '  Millions of tests per second:\t  $mTestsPerSecond \n' );
    }
    // stackoverflow maybe overkill!
    public static
    function floatToStringPrecision( n: Float, prec: Int )
    {
        if(n==0)
            return "0." + ([for(i in 0...prec) "0"].join("")); //quick return

        var minusSign:Bool = (n<0.0);
        n = Math.abs(n);
        var intPart:Int = Math.floor(n);
        var p = Math.pow(10, prec);
        var fracPart = Math.round( p*(n - intPart) );
        var buf:StringBuf = new StringBuf();

        if(minusSign)
            buf.addChar("-".code);
        buf.add(Std.string(intPart));

        if(fracPart==0)
        {
            buf.addChar(".".code);
            for(i in 0...prec)
                buf.addChar("0".code);
        }
        else 
        {
            buf.addChar(".".code);
            p = p/10;
            var nZeros:Int = 0;
            while(fracPart<p)
            {
                p = p/10;
                buf.addChar("0".code);
            }
            buf.add(fracPart);
        }
        return buf.toString();
    }
}