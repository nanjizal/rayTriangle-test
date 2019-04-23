package rayTriangle;
#if avoid_typedef
@:structInit
class V3 {
    public var x: Float;
    public var y: Float;
    public var z: Float; 
    private
    function new( x: Float, y: Float, z: Float ){
        this.x = x;
        this.y = y;
        this.z = z;
    }
}
#else
typedef V3 = {
    public var x: Float;
    public var y: Float;
    public var z: Float;
}
#end
@:forward
abstract Vec3( V3 ) from V3 to V3 {
    public new( v: V3 ) {
        this = v;
    }
    @:op(A - B)
    public static inline
    function subtract( a: Vec3, b: Vec3 ): Vec3 {
            return new Vec3({ x: a.x - b.x
                            , y: a.y - b.y
                            , z: a.z - b.z });
    }
    public inline
    function dot( v: Vec3 ): Float{
      return this.x * v.x + this.y * v.y + this.z * v.z;
    }
    @:op(A % B)
    public static inline
    function cross( a: Vec3, b: Vec3 ): Vec3 {
            return new Vec3({  x: a.y * b.z - a.z * b.y
                             , y: a.z * b.x - a.x * b.z
                             , z: a.x * b.y - a.y * b.x });
    }
    public inline
    function length(): Float {
        return Math.sqrt( this.x*this.x + this.y*this.y + this.z*this.z );
    }
    public inline
    function normalize(): Vec3 {
        var len = length();
        return new Vec3( { x: this.x/len, this.y: y/len, z: this.z/len } );
    }
    public inline
    function toString(): String {
        return "[$x, $y, $z]";
    }
}