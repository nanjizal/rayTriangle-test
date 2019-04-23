package rayTriangle;
#if avoid_typedef
@:structInit
class Ray {
    public var orig: Vec3;
    public var dir:  Vec3;
    private
    function new( orig: Vec3, dir: Vec3 ){
        this.orig = orig;
        this.dir = dir;
    }
}
#else
typedef Ray = {
    public var orig: Vec3;
    public var dir:  Vec3;
}
#end