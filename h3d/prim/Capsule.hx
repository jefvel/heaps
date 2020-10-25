package h3d.prim;
import h3d.col.Point;

class Capsule extends Polygon {

	@:s var radius : Float;
	@:s var segsH : Int;
	@:s var segsW : Int;

	public function new( radius = 1., length = 1., segsW = 8, segsH = 6 ) {
		this.radius = radius;
		this.segsH = segsH;
		this.segsW = segsW;

		var dp = Math.PI * 2 / segsW;
		var pts = [], idx = new hxd.IndexBuffer();
		var dx = 1, dy = segsW + 1;
		for( y in 0...segsH+1 ) {
			var t = (y / segsH) * Math.PI;
			var st = Math.sin(t);
			var pz = Math.cos(t);
			var p = 0.;
			for( x in 0...segsW+1 ) {
				var px = st * Math.cos(p);
				var py = st * Math.sin(p);
				var i = pts.length;
				pts.push(new Point(px * radius, py * radius, pz * radius - length * 0.5));
				p += dp;
			}
		}

		for( y in 0...segsH+1 ) {
			var t = (y / segsH) * Math.PI;
			var st = Math.sin(t);
			var pz = Math.cos(t);
			var p = 0.;
			for( x in 0...segsW+1 ) {
				var px = st * Math.cos(p);
				var py = st * Math.sin(p);
				var i = pts.length;
				pts.push(new Point(px * radius, py * radius, pz * radius + length * 0.5));
				p += dp;
			}
		}

		for( y in 0...segsH * 2 ) {
			for( x in 0...segsW * 2 ) {
				inline function vertice(x, y) return x + y * (segsW + 1);
				var v1 = vertice(x + 1, y);
				var v2 = vertice(x, y);
				var v3 = vertice(x, y + 1);
				var v4 = vertice(x + 1, y + 1);
				if( y != 0 ) {
					idx.push(v1);
					idx.push(v2);
					idx.push(v4);
				}
				if( y != segsH - 1 ) {
					idx.push(v2);
					idx.push(v3);
					idx.push(v4);
				}
			}
        }

		super(pts, idx);
	}

	override public function getCollider() : h3d.col.Collider {
		return new h3d.col.Sphere(translatedX, translatedY, translatedZ, radius * scaled);
	}

	override function addNormals() {
		normals = points;
	}

	override function addUVs() {
		uvs = [];
		for( y in 0...segsH + 1 )
			for( x in 0...segsW + 1 )
				uvs.push(new UV(1 - x / segsW, y / segsH));
	}

	public static function defaultUnitSphere() {
		var engine = h3d.Engine.getCurrent();
		var s : Sphere = @:privateAccess engine.resCache.get(Sphere);
		if( s != null )
			return s;
		s = new h3d.prim.Sphere(1, 16, 16);
		s.addNormals();
		s.addUVs();
		@:privateAccess engine.resCache.set(Sphere, s);
		return s;
	}

}
