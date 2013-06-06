package sgf;

class Node implements Dynamic {
	
	public var children : Array<Node>;
	
	public function new() {
		 children = new Array<Node>();
	}
	
	/*
	#if DEBUG
	public function toString() : String {
		for( n in Reflect.fields( this ) ) {
			trace( Reflect.field( this, n ) );
		}
		return "SGF.node()";
	}
	#end
	*/
	
}
